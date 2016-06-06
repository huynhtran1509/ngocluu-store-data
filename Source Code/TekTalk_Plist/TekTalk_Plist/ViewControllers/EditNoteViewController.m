//
//  EditNoteViewController.m
//  TekTalk_Plist
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "EditNoteViewController.h"
#import "Note.h"
#import "NoteDatabase.h"

@interface EditNoteViewController () <UITextViewDelegate>
{
    NSDateFormatter *_dataFormatter;
}

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UIButton *timeButton;
@property (nonatomic, weak) IBOutlet UITextView *textTextView;

@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataFormatter = [[NSDateFormatter alloc] init];
    _dataFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    if (!_note) {
        _note = [[NoteDatabase shareInstance] newNote];
        _note.time = [NSDate date];
    }
    
    NSDate *date = _note.time;
    NSString *textButton = [_dataFormatter stringFromDate:date];
    [_timeButton setTitle:textButton forState:UIControlStateNormal];
    
    _textTextView.text = _note.text;
}

- (IBAction)onTimeButtonClick:(id)sender
{
    [self.view endEditing:YES];
    _datePicker.hidden = !_datePicker.hidden;
}

- (IBAction)onDatePickerChange:(id)sender
{
    NSString *textButton = [_dataFormatter stringFromDate:_datePicker.date];
    [_timeButton setTitle:textButton forState:UIControlStateNormal];
    _note.time = _datePicker.date;
}

- (void)hidenKeyboard
{
    [super hidenKeyboard];
    _datePicker.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _note.text = _textTextView.text;
    [[NoteDatabase shareInstance] saveChange:_note];
}

@end
