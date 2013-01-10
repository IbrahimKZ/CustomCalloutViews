
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SMCalloutView.h"

@interface NewMapViewController : UIViewController <MKMapViewDelegate, SMCalloutViewDelegate>
@property (nonatomic, strong) NSArray *stocks;
@end

@interface MapAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString *title, *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property int idAnn;
@end

@interface CustomPinAnnotationView : MKPinAnnotationView
@property (strong, nonatomic) SMCalloutView *calloutView;
@property int idAnn;
@end
