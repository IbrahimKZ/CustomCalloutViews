
#import "NewMapViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewMapViewController{
    SMCalloutView *calloutView;
    MKMapView *mapView;
    NSMutableArray *pins;
    int idAnn;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        pins = [NSMutableArray array];
        self.stocks = @[
            @{@"img" : @"1.jpg", @"title" : @"Бургеры, салаты, курочка и многое другое в сети ресторанов быстрого питания «DAL's Burger» и «Gold'n'Brown». Скидка 50%", @"price" : @"50% за 99 тг.", @"lat" : @"43.20138", @"lng" : @"76.90597"},
            @{@"img" : @"2.jpg", @"title" : @"Гамбургеры, сэндвичи, картофель фри и различные напитки в фаст-фуде «Starburger» торгового центра «Алмалы». Скидка 50%", @"price" : @"50% за 89 тг.", @"lat" : @"43.23765", @"lng" : @"76.94622"},
            @{@"img" : @"3.jpg", @"title" : @"Блюда европейской и национальной кухни в кафе «Apricot». Скидка 50%", @"price" : @"50% за 399 тг.", @"lat" : @"43.24193", @"lng" : @"76.92769"},
            @{@"img" : @"4.jpg", @"title" : @"Барашек на вертеле, утка в яблоках, шашлык и многое другое в роскошном ресторане «Сарай». Скидка до 60%", @"price" : @"13000 тг. - 50% = 6500 тг.", @"lat" : @"43.21395", @"lng" : @"76.89278"},
            @{@"img" : @"5.jpg", @"title" : @"Блюда японской кухни + живое домашнее пиво в ресторане «У Афанасича». Скидка 50%", @"price" : @"50% за 500 тг.", @"lat" : @"43.21667", @"lng" : @"76.96446"},
            @{@"img" : @"6.jpg", @"title" : @"Две пиццы по цене одной в итальянском ресторане «Del Papa». Скидка 50%", @"price" : @"3000 тг. - 50% = 1499 тг.", @"lat" : @"43.25417", @"lng" : @"76.94035"}
                       ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setMap];
    [self drawMarkers];
}

- (void)setMap
{
    // setting the map
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    mapView.delegate = self;
    calloutView = [SMCalloutView new];
    calloutView.delegate = self;
    [self.view addSubview:mapView];
    
    // show this location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 43.25;
    newRegion.center.longitude = 76.92;
    newRegion.span.latitudeDelta = 0.1;
    newRegion.span.longitudeDelta = 0.1;
    [mapView setRegion:newRegion animated:YES];
    
    // adding a button in CalloutView
    UIButton *bottomDisclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [bottomDisclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMarker)]];
    calloutView.rightAccessoryView = bottomDisclosure;
}

- (void)drawMarkers
{
    for (int i = 0; i < [self.stocks count]; i++)
    {
        NSDictionary *item = [self.stocks objectAtIndex:i];
        MapAnnotation *capeCanaveral = [MapAnnotation new];
        capeCanaveral.idAnn = i;
        capeCanaveral.coordinate = (CLLocationCoordinate2D){[[item objectForKey:@"lat"] floatValue], [[item objectForKey:@"lng"] floatValue]};
        capeCanaveral.title = @"---";
        
        CustomPinAnnotationView *bottomPin = [[CustomPinAnnotationView alloc] initWithAnnotation:capeCanaveral reuseIdentifier:@""];
        bottomPin.image = [UIImage imageNamed:@"map.png"];
        bottomPin.idAnn = i;
        [pins addObject:bottomPin];
        
        [mapView addAnnotation:capeCanaveral];
    }
}

- (void)goToMarker
{
    // Change this for your case
    NSDictionary *item = [self.stocks objectAtIndex:idAnn];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ура!"
                                                    message:[item objectForKey:@"title"]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - MKMapView

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MapAnnotation *)annotation {
    if ([annotation isMemberOfClass:[MapAnnotation class]])
    {
        return [pins objectAtIndex:annotation.idAnn];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(CustomPinAnnotationView *)view {
    // dismiss out callout if it's already shown but on a different parent view
    if (calloutView.window)
		[calloutView dismissCalloutAnimated:NO];
    
    if ([view isMemberOfClass:[CustomPinAnnotationView class]])
    {
        idAnn = view.idAnn;
    }
    
	[self performSelector:@selector(popupMapCalloutView) withObject:nil afterDelay:1.0/3.0];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	// again, we'll introduce an artifical delay to feel more like MKMapView for this demonstration.
    [calloutView performSelector:@selector(dismissCalloutAnimated:) withObject:nil afterDelay:1.0/3.0];
}

#pragma mark - SMCalloutView

- (void)popupMapCalloutView {
    
    // Change this for creating your Callout View
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 88)];
    
    NSDictionary *item = [self.stocks objectAtIndex:idAnn];
    
    UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 88.0, 88.0)];
    photo.image = [UIImage imageNamed:[item objectForKey:@"img"]];
    photo.contentMode = UIViewContentModeScaleAspectFit;
    photo.layer.cornerRadius = 15.0;
    photo.layer.masksToBounds = YES;
    [customView addSubview:photo];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 0.0, 170.0, 72.0)];
    title.font = [UIFont systemFontOfSize:12.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.backgroundColor = [UIColor clearColor];
    title.text = [item objectForKey:@"title"];
    [customView addSubview:title];
    
    UILabel *discount = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 75.0, 160.0, 14.0)];
    discount.font = [UIFont systemFontOfSize:12.0];
    discount.textAlignment = NSTextAlignmentLeft;
    discount.textColor = [UIColor yellowColor];
    discount.backgroundColor = [UIColor clearColor];
    discount.text = [item objectForKey:@"price"];
    [customView addSubview:discount];
    
	// if you provide a custom view for the callout content, the title and subtitle will not be displayed
	calloutView.contentView = customView;
	CustomPinAnnotationView *bottomPin = [pins objectAtIndex:idAnn];
	bottomPin.calloutView = calloutView;
	[calloutView presentCalloutFromRect:bottomPin.bounds
                                 inView:bottomPin
                      constrainedToView:mapView
               permittedArrowDirections:SMCalloutArrowDirectionAny
                               animated:YES];
}

- (NSTimeInterval)calloutView:(SMCalloutView *)theCalloutView delayForRepositionWithSize:(CGSize)offset {
    
    // Uncomment this to cancel the popup
    // [calloutView dismissCalloutAnimated:NO];
	
	// if annotation view is coming from MKMapView, it's contained within a MKAnnotationContainerView instance
	// so we need to adjust the map position so that the callout will be completely visible when displayed
	if ([NSStringFromClass([calloutView.superview.superview class]) isEqualToString:@"MKAnnotationContainerView"]) {
		CGFloat pixelsPerDegreeLat = mapView.frame.size.height / mapView.region.span.latitudeDelta;
		CGFloat pixelsPerDegreeLon = mapView.frame.size.width / mapView.region.span.longitudeDelta;
		
		CLLocationDegrees latitudinalShift = offset.height / pixelsPerDegreeLat;
		CLLocationDegrees longitudinalShift = -(offset.width / pixelsPerDegreeLon);
		
		CGFloat lat = mapView.region.center.latitude + latitudinalShift;
		CGFloat lon = mapView.region.center.longitude + longitudinalShift;
		CLLocationCoordinate2D newCenterCoordinate = (CLLocationCoordinate2D){lat, lon};
		if (fabsf(newCenterCoordinate.latitude) <= 90 && fabsf(newCenterCoordinate.longitude <= 180)) {
			[mapView setCenterCoordinate:newCenterCoordinate animated:YES];
		}
	}
    
    return kSMCalloutViewRepositionDelayForUIScrollView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation MapAnnotation @end

@implementation CustomPinAnnotationView
@synthesize calloutView;
- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
    if (calloutMaybe) return calloutMaybe;
	
    return [super hitTest:point withEvent:event];
}
@end
