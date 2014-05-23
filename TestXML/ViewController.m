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
    NSMutableData *dados;
    NSMutableArray *itens;
    NSMutableDictionary *item;
    NSString *nodeValue;
}

@end

@implementation ViewController

static BOOL parsedElement = NO;
static BOOL isInNode = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dados = [[NSMutableData alloc] init];
    itens = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://feeds.feedburner.com/blogmacmagazine?format=xml"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    
    [con start];
    
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
    
    NSString *xml = [[NSString alloc] initWithData:dados encoding:NSUTF8StringEncoding];
    
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];
    [parser parse];
}

#pragma mark - Métodos do delegate do NSXMLParser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc] init];
        isInNode = YES;
    }
    
    if (isInNode && ([elementName isEqualToString:@"title"] || [elementName isEqualToString:@"description"])) {
        parsedElement = YES;
        nodeValue = @"";
        // entra na tag
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [itens addObject:item];
        isInNode = NO;
    }
    
    if (([elementName isEqualToString:@"title"] || [elementName isEqualToString:@"description"])) {
        [item setObject:nodeValue forKey:elementName];
        
        parsedElement = NO;
        // sai da tag
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(parsedElement)
    {
        nodeValue = [nodeValue stringByAppendingString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    // acha valor dentro da tag
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger numSections = 1;
    
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger numRows = [itens count];
    
    return numRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName = @"Notícias";
    
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"Celula";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // Configure the cell...
    
    [[cell textLabel] setText:[[itens objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *description = [[itens objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    UIView *view = [[UIView alloc] init];
    [view setFrame:self.view.frame];
    
    UITextView *textView = [[UITextView alloc] init];
    [textView setFrame:view.frame];
    [textView setEditable:NO];
    [textView setText:description];
    
    [view addSubview:textView];
    
    [self.view addSubview:view];
}

@end
