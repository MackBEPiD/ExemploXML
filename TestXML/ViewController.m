//
//  ViewController.m
//  TestXML
//
//  Created by Lucas Salton Cardinali on 5/19/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString * xml;
    NSString * currentElement;
    NSString * carret;
}

@end

@implementation ViewController

static BOOL parsedElement = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     xml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Contatos" ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];
    [parser parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"nome"])
        carret = @"  NOME: ";
    else if([elementName isEqualToString:@"idade"])
        carret = @"\t IDADE: ";
    currentElement = elementName;
    parsedElement = YES;
    // entra na tag
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    NSLog(@"%@",carret);
    carret = @"";
    currentElement = nil;
    parsedElement = NO;
    // sai da tag
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(parsedElement)
    {
        if([currentElement isEqualToString:@"nome"])
            carret = [NSString stringWithFormat:@"%@%@",carret,[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        else if([currentElement isEqualToString:@"idade"])
            carret = [NSString stringWithFormat:@"%@%@",carret,[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    // acha valor dentro da tag
}











@end
