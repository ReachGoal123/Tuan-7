
//
//  MapViewController.m
//  Tuan
//
//  Created by tarena on 15-4-1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//
#import "DianpingApi.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "BusinessInfo.h"
#import "MyAnnotation.h"
@interface MapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong)NSMutableDictionary *params;
@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.params = [NSMutableDictionary dictionary];
    
    CLLocationCoordinate2D coord;
    coord.longitude = 116.3972282409668;
    coord.latitude = 39.90960456049752;
    [self.params setObject:@(coord.longitude) forKey:@"longitude"];
    [self.params setObject:@(coord.latitude) forKey:@"latitude"];
    [self.params setObject:@"5000" forKey:@"radius"];
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
        [self addAnnotationsByArr:obj];
        
        
    }];


    
    
    
    [self.mapView setRegion:MKCoordinateRegionMake(coord, MKCoordinateSpanMake(0.1, 0.1)) animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"位置发生改变了");
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    CLLocationCoordinate2D coord = mapView.centerCoordinate;
    //需要发出请求 并且把当前位置的坐标作为参数
    [self.params setObject:@(coord.longitude) forKey:@"longitude"];
    [self.params setObject:@(coord.latitude) forKey:@"latitude"];
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
        [self addAnnotationsByArr:obj];
        
        
    }];
}


-(void)addAnnotationsByArr:(NSArray *)arr{
    
    
    for (BusinessInfo *bi in arr) {
        MyAnnotation *ann = [[MyAnnotation alloc]init];
        CLLocationCoordinate2D coord;
        coord.longitude = bi.longitude;
        coord.latitude = bi.latitude;
        
        ann.coordinate = coord;
        ann.title = bi.name;
        
        [self.mapView addAnnotation:ann];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
