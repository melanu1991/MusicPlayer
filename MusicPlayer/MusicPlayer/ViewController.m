#import "ViewController.h"

static NSUInteger const CountSounds = 4;
static NSString * const Sounds[CountSounds] = { @"zebrahead_-_call_your_friends.mp3", @"zebrahead_-_headrush.mp3", @"zebrahead_-_hell_yeah.mp3", @"zebrahead-girlfriend.mp3" };

@interface ViewController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (assign, nonatomic) NSInteger numberCurrentSound;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *passedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stayedTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *prevSoundButton;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *nextSoundButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

#pragma mark - life cycle view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAudioPlayer];
}

#pragma mark - helpers

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
}

- (void)updateTime {
    self.slider.value = self.audioPlayer.currentTime;
    self.passedTimeLabel.text = [self passedTime];
    self.stayedTimeLabel.text = [self stayedTime];
}

- (void)setupAudioPlayer {
    NSString *path = [[NSBundle mainBundle] pathForResource:Sounds[self.numberCurrentSound] ofType:nil];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.audioPlayer.delegate = self;
    self.slider.maximumValue = self.audioPlayer.duration;
}

- (void)setNumberOfSounds {
    if (self.numberCurrentSound < 0) {
        self.numberCurrentSound = CountSounds - 1;
    }
    else if (self.numberCurrentSound > CountSounds - 1) {
        self.numberCurrentSound = 0;
    }
}

- (NSString *)passedTime {
    NSInteger sendTime = self.audioPlayer.duration - (self.audioPlayer.duration - self.audioPlayer.currentTime);
    NSInteger sendMinutes = sendTime / 60;
    NSInteger sendSeconds = sendTime - sendMinutes * 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", sendMinutes, sendSeconds];
}

- (NSString *)stayedTime {
    NSInteger stayTime = self.audioPlayer.duration - self.audioPlayer.currentTime;
    NSInteger stayMinutes = stayTime / 60;
    NSInteger staySeconds = stayTime - stayMinutes * 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)stayMinutes, (long)staySeconds];
}

#pragma mark - action

- (IBAction)rewindSound:(UISlider *)sender {
    self.audioPlayer.currentTime = sender.value;
    [self updateTime];
}

- (IBAction)rewindSoundUsingTouch:(UISlider *)sender {
    NSLog(@"touch");
}

- (IBAction)prevButtonPressed:(UIButton *)sender {
    --self.numberCurrentSound;
    [self setNumberOfSounds];
    [self setupAudioPlayer];
    [self.audioPlayer play];
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    self.numberCurrentSound++;
    [self setNumberOfSounds];
    [self setupAudioPlayer];
    [self.audioPlayer play];
}

- (IBAction)playOrPauseButtonPressed:(UIButton *)sender {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self stopTimer];
    }
    else {
        [self.audioPlayer play];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self startTimer];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self nextButtonPressed:nil];
}

@end
