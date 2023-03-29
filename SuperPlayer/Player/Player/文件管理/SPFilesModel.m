//
//  SPFilesModel.m
//  Player
//
//  Created by hz on 2021/11/10.
//

#import "SPFilesModel.h"

@implementation SPFilesModel

- (void)setFileSize:(long long)fileSize {
    _fileSize = fileSize;
    
    
    float kSize = fileSize*1.0/1000;
    float mSize = fileSize*1.0/1000/1000;
    if (kSize<1000) {
        self.fileSizeStringValue = [NSString stringWithFormat:@"%.1f KB ",kSize];
    } else if (mSize<1000) {
        self.fileSizeStringValue = [NSString stringWithFormat:@"%.1f M ",mSize];
    } else {
        self.fileSizeStringValue = [NSString stringWithFormat:@"%.1f G ",mSize/1000];
    }
}

- (void)setCreateDate:(NSDate *)createDate {
    _createDate = createDate;
    self.createTs = [createDate timeIntervalSince1970]*1000;
    if (self.name) {
        self.fileId = [NSString stringWithFormat:@"%@_%@",self.name,@(self.createTs)];
    }
}

- (void)setName:(NSString *)name {
    _name = name;
    if (self.createTs) {
        self.fileId = [NSString stringWithFormat:@"%@_%@", name,@(self.createTs)];
    }
}



@end
