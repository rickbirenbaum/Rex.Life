//
//  CustomRecsTableViewCell.h
//  RexTile
//
//  Created by Sweety Singh on 1/2/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomRecsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblRecName;
@property (weak, nonatomic) IBOutlet UILabel *lblRecAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblRecCount;
@property (weak, nonatomic) IBOutlet UILabel *lblRecDistance;


@end
