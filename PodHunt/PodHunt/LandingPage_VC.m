//
//  LandingPage_VC.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+HoneyPotColorPallette.h"
#import "LandingPage_VC.h"
#import "gitHubLogin_VC.h"
#import "GitHubLogin.h"
#import "UserSplashPageController.h"
#import "UserSplashPage.h"
#import "GitHubAPIRequestManager.h"

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

static NSString * const kCocoaPodsEndPoint = @"http://search.cocoapods.org/api/pods";
static NSString * const kCocoaPodsAcceptHeader = @"application/vnd.cocoapods.org+picky.hash.json; version=1";

@interface CocoaPodsAPIManager : NSObject

-(void) searchFor:(NSString *)query forPlatform:(NSString *)platform limitResults:(NSInteger)resultsize;

@end

@implementation CocoaPodsAPIManager

-(void)searchFor:(NSString *)query forPlatform:(NSString *)platform limitResults:(NSInteger)resultsize{
    
}

@end



@interface LandingPage_VC () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

@property (strong,  nonatomic)      UIView      * rootView;
@property (strong,  nonatomic)      UIView      * contentView;

@property (strong,  nonatomic)      UISearchBar * searchBar;
@property (strong,  nonatomic)      UISearchController * searchBarController;

@property (weak,    nonatomic)      UIButton    * loginButton;

@property (strong,  nonatomic)      UserSplashPage * splashPage;
@property (strong,  nonatomic)      UITableView * splashStarTable;
@property (strong,  nonatomic)      UITableView * splashForkTable;

@property (strong, nonatomic)       GitHubAPIRequestManager * sharedAPIManager;

@property (strong, nonatomic)       UIViewController * leftMenuViewController;

@end

@implementation LandingPage_VC

-(instancetype)init{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - 44.0)];
        [self.view addSubview:_contentView];
        
        
        
        _searchBar = [[UISearchBar alloc] init];
        _splashPage = [[UserSplashPage alloc] initWithFrame:_contentView.bounds];
        [_splashPage setBackgroundColor:[UIColor eggShellWhite]];
        [_contentView addSubview:_splashPage];
        [_contentView addSubview:_searchBar];
        
        _searchBar.delegate = self;
        
        _splashStarTable = _splashPage.starredTable;
        _splashForkTable = _splashPage.forkedTable;
        _splashStarTable.delegate = self;
        _splashForkTable.delegate = self;
 
        _searchBarController = [[UISearchController alloc] initWithSearchResultsController:self];
        _searchBarController.delegate = self;
        _sharedAPIManager = [GitHubAPIRequestManager sharedManager];
    }
    return self;
}

-(void)loadView
{
    _rootView = [[UIView alloc] init];
    [self setView:_rootView];
}

-(void)viewWillLayoutSubviews
{
    
    [_searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray * searchBarConstraints = @[ [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBar]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_searchBar)],
                                        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchBar]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_searchBar)]
                                       ];
    
    for (NSArray * constraint in searchBarConstraints) {
        [_contentView addConstraints: constraint];
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"The search controller %@", searchController);
    [searchController setActive:YES];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self updateSearchResultsForSearchController:self.searchBarController];
    
    NSLog(@"Search Text");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"PodHunt";
    self.leftMenuViewController = [[UIViewController alloc] init];

    // -- MMDrawerBarButton -- //
    UIBarButtonItem * hamburger = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftMenu)];
    self.navigationItem.leftBarButtonItem = hamburger;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// -- MMDrawerMenu -- //
-(void) leftMenu{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = @"Yo";
    
    return cell;
    
}

// -- misc methods -- //
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
