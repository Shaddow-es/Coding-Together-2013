//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by David Muñoz Fernández on 02/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//
//  Will call setImageURL: as part of any "Show Image" segue.

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTVC () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoTVC

// ---------------------------------------
//  -- UISplitViewControllerDelegate
// ---------------------------------------
#pragma mark - UISplitViewControllerDelegate

- (void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL) splitViewController:(UISplitViewController *)svc
    shouldHideViewController:(UIViewController *)vc
               inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private Methods

- (NSString *) titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *) subtitleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_OWNER] description];
}

// ---------------------------------------
//  -- Table view data source
// ---------------------------------------

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

// ---------------------------------------
//  -- Table view delegate
// ---------------------------------------

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSDictionary *photo = self.photos[indexPath.row];
                    NSURL *url = [photo objectForKey:@"PATH"];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

@end
