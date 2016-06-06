//
//  NotesViewController.m
//  TekTalk_Plist
//
//  Created by luu on 6/3/16.
//  Copyright (c) 2016 luu. All rights reserved.
//

#import "NotesViewController.h"
#import "NoteDatabase.h"
#import "Note.h"
#import "EditNoteViewController.h"

NSString *const kNoteCellIdentifier = @"kNoteCellIdentifier";

@interface NotesViewController ()
{
    Note *_selectedNote;
    NSArray *_notes;
    NSDateFormatter *_dataFormatter;
}

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataFormatter = [[NSDateFormatter alloc] init];
    _dataFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reload];
}

- (void)reload
{
    _notes = [[NoteDatabase shareInstance] allNote];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _notes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoteCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Note *note = _notes[indexPath.row];
    cell.textLabel.text = note.text;
    cell.detailTextLabel.text = [_dataFormatter stringFromDate:note.time];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Note *note = _notes[indexPath.row];
        [[NoteDatabase shareInstance] deleteNote:note];
        _notes = [[NoteDatabase shareInstance] allNote];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedNote = _notes[indexPath.row];
    [self performSegueWithIdentifier:@"edit_note" sender:self];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"edit_note"]) {
        EditNoteViewController *editViewController = [segue destinationViewController];
        if (_selectedNote) {
            editViewController.note = _selectedNote;
            _selectedNote = nil;
        }
    }
}

@end
