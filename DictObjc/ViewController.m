//
//  ViewController.m
//  DictObjc
//
//  Created by Hank Bao on 16/4/17.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

#import "ViewController.h"
#import "QueryRecord.h"
#import "DataSource.h"

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, strong) DataSource *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupData];
    [self setupUI];

    self.tableView.keyboardDismissMode
        = UIScrollViewKeyboardDismissModeOnDrag;

    [self.view becomeFirstResponder];
}

- (void)setupData {
    self.dataSource = [[DataSource alloc] initWithCellConfigure:
                            ^UITableViewCell *(UITableViewCell *cell, QueryRecord *record) {
                                cell.textLabel.text = record.term;
                                cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:record.date
                                                                                           dateStyle:NSDateFormatterShortStyle
                                                                                           timeStyle:NSDateFormatterShortStyle];
                                UILabel *countLabel = (UILabel *) cell.accessoryView;
                                if (!countLabel) {
                                    CGRect frame = {
                                        .origin.x = 0,
                                        .origin.y = 0,
                                        .size.width = 30,
                                        .size.height = 30
                                    };
                                    countLabel = [[UILabel alloc] initWithFrame:frame];
                                    cell.accessoryView = countLabel;
                                }
                                countLabel.text = [NSString stringWithFormat:@"%ld", record.queryCount];

                                return cell;
                            } reuseIdentifier:@"dict.objc.cell.simple"];

    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
}

- (void)setupUI {
    self.toolbar
        = [[UIToolbar alloc] initWithFrame:[self toolbarFrame]];
    self.toolbar.items = self.toolbarItems;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (CGRect)textFrame {
    return CGRectMake(0, 0, 300, 40);
}

- (CGRect)toolbarFrame {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    return CGRectMake(0, 0, screenBounds.size.width, 44);
}

- (UIBarButtonItem *)textItem {
    UITextField *textField
        = [[UITextField alloc] initWithFrame:[self textFrame]];
    textField.placeholder = @"Input word here.";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.textField = textField;
    self.textField.delegate = self;
    return [[UIBarButtonItem alloc] initWithCustomView:textField];
}

- (UIBarButtonItem *)spaceItem {
    return [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:nil action:NULL];
}

- (UIBarButtonItem *)searchItem {
    return [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
            target:self action:@selector(query:)];
}

- (NSArray<UIBarButtonItem *> *)toolbarItems {
    return @[[self textItem],
             [self spaceItem],
             [self searchItem]];
}

- (UIView *)inputAccessoryView {
    return self.toolbar;
}

- (void)queryTerm:(NSString *)term {
    self.textField.text = nil;

    BOOL isNewTerm = NO;
    NSIndexPath *indexPath = [self.dataSource addTerm:term isNewTerm:&isNewTerm];

    if (isNewTerm) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        NSIndexPath *to = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.dataSource moveTermAtIndexPath:indexPath toIndexPath:to];

        [self.tableView moveRowAtIndexPath:indexPath
                               toIndexPath:to];
        [self.tableView reloadRowsAtIndexPaths:@[to]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    UIViewController *libViewController
        = [[UIReferenceLibraryViewController alloc] initWithTerm:term];
    [self.navigationController pushViewController:libViewController animated:YES];
}

- (IBAction)query:(id)sender {
    NSString *term = self.textField.text;

    if (term && [UIReferenceLibraryViewController
                 dictionaryHasDefinitionForTerm:term]) {
        if ([sender respondsToSelector:@selector(resignFirstResponder)]) {
            [sender resignFirstResponder];
        }
        [self resignFirstResponder];
        [self queryTerm:term];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self query:textField];
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *term = [self.dataSource termAtIndexPath:indexPath];
    [self queryTerm:term];
}

@end
