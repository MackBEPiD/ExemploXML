//
//  TableViewController.m
//  TestXML
//
//  Created by Lucas Saito on 23/05/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "TableViewController.h"
#import "ContentViewController.h"

@interface TableViewController ()
{
    NSMutableData *dados;
    NSMutableArray *itens;
    NSMutableDictionary *item;
    NSString *nodeValue;
}

@end

@implementation TableViewController

static BOOL parsedElement = NO;
static BOOL isInNode = NO;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dados = [[NSMutableData alloc] init];
    itens = [[NSMutableArray alloc] init];
    
    [self setTitle:@"MacMagazine"];
    
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *sectionName = @"Notícias";
//    
//    return sectionName;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"Celula";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // Configure the cell...
    
    [[cell textLabel] setText:[[itens objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [[cell textLabel] setFont:[UIFont fontWithName:nil size:10]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentViewController *content = [[ContentViewController alloc] init];
    content.dados = [itens objectAtIndex:indexPath.row];
    
    [[self navigationController] pushViewController:content animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    
    if (isInNode && ([elementName isEqualToString:@"title"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"description"])) {
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
    
    if (([elementName isEqualToString:@"title"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"description"])) {
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

@end
