//
//  FilterTableViewCell.m
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.01.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "FilterTableViewCell.h"

@interface FilterTableViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UISlider *slider;

@end

@implementation FilterTableViewCell

- (void)setFilterModel:(FilterModel *)filterModel {
    _filterModel = filterModel;
    self.label.text = _filterModel.name;
    self.slider.minimumValue = _filterModel.minValue;
    self.slider.maximumValue = _filterModel.maxValue;
    self.slider.value = _filterModel.value;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    self.filterModel.value = sender.value;
}

- (IBAction)resetButtonPressed:(id)sender {
    self.filterModel.value = 0.0f;
    self.slider.value = 0.0f;
}

@end
