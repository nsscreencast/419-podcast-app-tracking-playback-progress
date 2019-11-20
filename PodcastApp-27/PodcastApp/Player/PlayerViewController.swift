//
//  PlayerViewController.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 8/8/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class PlayerViewController : UIViewController {

    private var player: AVPlayer?
    private var timeObservationToken: Any?
    private var statusObservationToken: Any?
    private let skipTime = CMTime(seconds: 10, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

    private var subscriptionStore: SubscriptionStore!
    private var episodeStatus: EpisodeStatusEntity?

    static var shared: PlayerViewController = {
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let playerVC = storyboard.instantiateInitialViewController() as! PlayerViewController
        _ = playerVC.view
        return playerVC
    }()

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var artworkShadowWrapper: UIView!
    @IBOutlet weak var transportSlider: UISlider!
    @IBOutlet weak var timeProgressedLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    @IBOutlet var playerBar: PlayerBar!

    weak var presentationRootController: UIViewController?

    // View Lifecycle

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscriptionStore = SubscriptionStore(context: PersistenceManager.shared.mainContext)

        playerBar.isHidden = true

        view.backgroundColor = Theme.Colors.gray4

        titleLabel.textColor = Theme.Colors.gray1
        timeRemainingLabel.textColor = Theme.Colors.gray2
        timeProgressedLabel.textColor = Theme.Colors.gray2

        timeRemainingLabel.text = nil
        timeProgressedLabel.text = nil

        artworkImageView.layer.masksToBounds = true
        artworkImageView.layer.cornerRadius = 12
        artworkImageView.backgroundColor = Theme.Colors.gray4

        artworkShadowWrapper.backgroundColor = .clear
        artworkShadowWrapper.layer.shadowColor = UIColor.black.cgColor
        artworkShadowWrapper.layer.shadowOpacity = 0.9
        artworkShadowWrapper.layer.shadowOffset = CGSize(width: 0, height: 1)
        artworkShadowWrapper.layer.shadowRadius = 20

        transportSlider.setThumbImage(UIImage(named: "Knob"), for: .normal)
        transportSlider.setThumbImage(UIImage(named: "Knob-Tracking"), for: .highlighted)
        transportSlider.isEnabled = false

        let pauseImage = playPauseButton.image(for: .selected)
        let tintedImage = pauseImage?.tint(color: Theme.Colors.purpleDimmed)
        playPauseButton.setImage(tintedImage, for: [.selected, .highlighted])
        playerBar.playPauseButton.setImage(tintedImage, for: [.selected, .highlighted])
    }

    func setEpisode(_ episode: Episode, podcast: Podcast, autoPlay: Bool = true) {
        getEpisodeStatus(for: episode)
        updateUI(for: episode, podcast: podcast)

        guard let audioURL = episode.enclosureURL else { return }
        beginAudioSession()
        cleanupPlayerState()

        preparePlayer(audioURL: audioURL) {
            if autoPlay {
                self.player?.play()
                self.togglePlayPauseButton(isPlaying: true)
            }
        }
    }

    private func beginAudioSession() {
        do {
            try configureAudioSession()
        } catch {
            print("ERROR: \(error)")
            showAudioSessionError()
        }
    }

    private func preparePlayer(audioURL: URL, onReady: @escaping () -> Void) {
        let playerItem = AVPlayerItem(url: audioURL)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player

        let time = episodeStatus?.lastListenTime ?? 0
        transportSlider.value = 0
        transportSlider.isEnabled = false
        transportSlider.alpha = 0.5

        statusObservationToken = playerItem.observe(\.status) { (playerItem, change) in
            print("Status: ")
            switch playerItem.status {
            case .failed:
                print("Failed.")
                print("Error: ", playerItem.error?.localizedDescription ?? "<?>")

            case .readyToPlay:
                print("Ready to play")

                player.seek(to: CMTime(seconds: time, preferredTimescale: 1))
                self.transportSlider.value = Float(time / max(playerItem.duration.seconds, 1))
                self.transportSlider.alpha = 1
                self.transportSlider.isEnabled = true

                onReady()

            case .unknown:
                print("Unknown")
            @unknown default:
                break
            }
        }

        let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObservationToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateSlider(for: time)

            self?.episodeStatus?.lastListenTime = time.seconds

            self?.timeProgressedLabel.text = time.formattedString
            if let duration = player.currentItem?.duration {
                let remaining = duration - time
                self?.timeRemainingLabel.text = "-" + remaining.formattedString
            } else {
                self?.timeRemainingLabel.text = "--"
            }
        }
    }

    private func getEpisodeStatus(for episode: Episode) {
        do {

            if let previousStatus = try subscriptionStore.findCurrentlyPlayingEpisode() {
                previousStatus.isCurrentlyPlaying = false
            }

            episodeStatus = try subscriptionStore.getStatus(for: episode)
            episodeStatus?.isCurrentlyPlaying = true
            episodeStatus?.lastPlayedAt = Date()

            try PersistenceManager.shared.mainContext.save()

        } catch {
            print("Error: ", error)
        }

        if episodeStatus == nil {
            print("WARNING: Episode status was not returned. No progress will be saved.")
        }
    }

    private func updateUI(for episode: Episode, podcast: Podcast) {
        titleLabel.text = episode.title
        artworkImageView.kf.setImage(with: podcast.artworkURL, options: [.transition(.fade(0.3))])
        playerBar.imageView.kf.setImage(with: podcast.artworkURL)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playerBar.isHidden = false
        }
    }

    private func cleanupPlayerState() {
        if player != nil {
            player?.pause()
            if let previousObservation = timeObservationToken {
                player?.removeTimeObserver(previousObservation)
            }
            player = nil
        }
    }

    private func updateSlider(for time: CMTime) {
        guard !transportSlider.isTracking else { return }
        guard let duration = player?.currentItem?.duration else { return }
        let progress = time.seconds / duration.seconds
        transportSlider.value = Float(progress)
    }

    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback)
        try session.setMode(.spokenAudio)
        try session.setActive(true, options: [])
    }

    private func showAudioSessionError() {
        let alert = UIAlertController(title: "Playback Error", message: "There was an error configuring the audio system for playback.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func transportSliderChanged(_ sender: Any) {
        guard let player = player else { return }
        guard let currentItem = player.currentItem else { return }

        let seconds = currentItem.duration.seconds * Double(transportSlider.value)
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: time)
    }

    @IBAction func skipBack(_ sender: Any) {
        guard let player = player else { return }

        let time = player.currentTime() - skipTime
        if time < CMTime.zero {
            player.seek(to: .zero)
            updateSlider(for: .zero)
        } else {
            player.seek(to: time)
            updateSlider(for: time)
        }
    }

    @IBAction func skipForward(_ sender: Any) {
        guard let player = player else { return }
        guard let currentItem = player.currentItem else { return }

        let time = player.currentTime() + skipTime
        if time >= currentItem.duration {
            player.seek(to: currentItem.duration)
            updateSlider(for: currentItem.duration)
        } else {
            player.seek(to: time)
            updateSlider(for: time)
        }
    }

    @IBAction func playPause(_ sender: Any) {
        let wasPlaying = playPauseButton.isSelected
        togglePlayPauseButton(isPlaying: !wasPlaying)

        if wasPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }

    private func togglePlayPauseButton(isPlaying: Bool) {
        playPauseButton.isSelected = isPlaying
        playerBar.playPauseButton.isSelected = isPlaying
    }

    @IBAction func presentPlayer() {
        presentationRootController?.present(PlayerViewController.shared, animated: true, completion: nil)
    }
}
