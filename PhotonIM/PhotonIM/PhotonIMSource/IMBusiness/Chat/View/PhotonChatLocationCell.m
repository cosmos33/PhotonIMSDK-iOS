//
//  PhotonChatLocationCell.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatLocationCell.h"
#import "PhotonChatLocationItem.h"
#import <MapKit/MapKit.h>
@interface PhotonChatLocationCell()
@property(nonatomic, strong)UILabel  *addressLabel;
@property(nonatomic, strong)UILabel  *detailAddressLabel;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@end

@implementation PhotonChatLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentBackgroundView addSubview:self.addressLabel];
        [self.contentBackgroundView addSubview:self.detailAddressLabel];
        [self.contentBackgroundView addSubview:self.mapView];
      
    }
    return self;
}

- (void)setObject:(id)object{
    [super setObject:object];
    if (!self.item) {
        return;
    }
    PhotonChatLocationItem *locationItem = (PhotonChatLocationItem *)object;
    self.addressLabel.text = locationItem.address;
    self.detailAddressLabel.text = locationItem.detailAddress;
    [self p_moveToLocation:locationItem.locationCoordinate];
    
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.addressLabel.text = nil;
    self.detailAddressLabel.text = nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    PhotonChatLocationItem *item = (PhotonChatLocationItem *)self.item;
    CGFloat bgViewWidth = PhotoScreenWidth/2.0;
    PhotonChatMessageFromType fromType = item.fromType;
    CGSize bgViewSize = CGSizeMake(bgViewWidth, item.contentSize.height);
    CGRect contentBackgroundViewFrame = self.contentBackgroundView.frame;
    contentBackgroundViewFrame.size = bgViewSize;
    CGFloat contentBackgroundViewLeft = 0;
    if (fromType == PhotonChatMessageFromSelf) {
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x-contentBackgroundViewFrame.size.width;
    }else{
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x;
    }
    contentBackgroundViewFrame.origin.x = contentBackgroundViewLeft;
    self.contentBackgroundView.frame = contentBackgroundViewFrame;
    
    
    
    CGRect addressLabelFrame = self.addressLabel.frame;
    addressLabelFrame.size =CGSizeMake(bgViewWidth - 10, 20);
    
    CGRect detailAddressLabelFrame = self.detailAddressLabel.frame;
    detailAddressLabelFrame.size = CGSizeMake(bgViewWidth - 10, 15);
    
    CGRect mapFrame = self.mapView.frame;
    mapFrame.size = CGSizeMake(bgViewWidth - 10, 105);
    mapFrame.origin = CGPointMake(5, 50);
    
    addressLabelFrame.origin = CGPointMake(5, 5);
    detailAddressLabelFrame.origin = CGPointMake(5, 27);

    self.addressLabel.frame = addressLabelFrame;
    self.detailAddressLabel.frame = detailAddressLabelFrame;
    self.mapView.frame = mapFrame;
    
    [self subview_layout];
}

- (void)p_moveToLocation:(CLLocationCoordinate2D)locationCoordinate
{
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(locationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    [self.mapView removeAnnotation:self.annotation];
    self.annotation.coordinate = locationCoordinate;
    [self.mapView addAnnotation:self.annotation];
}

- (UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setFont:[UIFont systemFontOfSize:16.0]];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        [_addressLabel setNumberOfLines:0];
    }
    return _addressLabel;
}

- (UILabel *)detailAddressLabel{
    if (_detailAddressLabel == nil) {
        _detailAddressLabel = [[UILabel alloc] init];
        [_detailAddressLabel setFont:[UIFont systemFontOfSize:13.0]];
        _detailAddressLabel.textAlignment = NSTextAlignmentCenter;
        [_detailAddressLabel setNumberOfLines:0];
    }
    return _detailAddressLabel;
}

- (MKMapView *)mapView{
    if (!_mapView) {
         _mapView= [[MKMapView alloc] init];
         _mapView.mapType = MKMapTypeStandard;
         _mapView.zoomEnabled = NO;
        _mapView.rotateEnabled = NO;
        _mapView.pitchEnabled = NO;
        _mapView.scrollEnabled = NO;
        _mapView.layer.cornerRadius = 5;
        _mapView.clipsToBounds = YES;
        _annotation = [[MKPointAnnotation alloc] init];
    }
    return _mapView;
}


@end
