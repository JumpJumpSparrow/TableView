//
//  ProfileViewController.h
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/21.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseViewController.h"

@class MCFUserModel;
@interface ProfileViewController : BaseViewController

- (instancetype)initWithUser:(MCFUserModel *)user;
@end