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
    NSMutableData *dados;
}

@end

@implementation ViewController

static BOOL parsedElement = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dados = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://feeds.feedburner.com/blogmacmagazine?format=xml"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    
    //    xml = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Contatos" ofType:@"xml"] encoding:NSUTF8StringEncoding error:nil];
    //    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    //    [parser setDelegate:self];
    //    [parser parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Métodos do delegate do NSURLConnection

// enviado à medida que a conexão
// envia dados de modo incremental
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // código para tratar os dados recebidos
    [dados appendData:data];
}

// enviado quando a conexão acaba de carregar,
// ou seja, o delegate não vai mais receber
// mensagens dessa conexão
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // código para tratar o fim da conexão
    
    xml = [[NSString alloc] initWithData:dados encoding:NSUTF8StringEncoding];
    
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];
    [parser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"title"])
        carret = @"  TITLE: ";
    else if([elementName isEqualToString:@"link"])
        carret = @"\t LINK: ";
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
        if([currentElement isEqualToString:@"title"])
            carret = [NSString stringWithFormat:@"%@%@",carret,[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        else if([currentElement isEqualToString:@"link"])
            carret = [NSString stringWithFormat:@"%@%@",carret,[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    // acha valor dentro da tag
}

@end
