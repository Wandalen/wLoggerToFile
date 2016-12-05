# wLoggerToFile
Module in JavaScript providing convenient, layered, logging into file.

## wLoggerToFile
Logger that writes messages( incoming & outgoing ) to file specified by path( outputPath ).
Writes each message to the end of file, creates new file( outputPath ) if it doesn't exists.
Then transfers message to the next output(s) object in the chain if it exists.

## Installation
```terminal
npm install wLoggerToFile
```
## Usage
### Options
* outputPath { string }[ optional ] - output file path, default dirname/output.log.
* output { object }[ optional ] - single output object for current logger, null by default.

### Methods
Output:
* log
* error
* info
* warn

Chaining:
*  Add object to output list - [outputTo](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputTo)
*  Remove object from output list - [outputToUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.outputToUnchain)
*  Add current logger to target's output list - [inputFrom](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFrom)
*  Remove current logger from target's output list - [inputFromUnchain](https://rawgit.com/Wandalen/wLogger/master/doc/reference/wPrinterBase.html#.inputFromUnchain)

##### Example #1
```javascript
/*Logging to specified file*/
var l = new wLoggerToFile
({
  outputPath : 'out.txt'
});
l.log( 'aa\nbb' );
```
##### Example #2
```javascript
/*Add console as output*/
var l = new wLoggerToFile
({
  output : console,
  outputPath : 'out2.txt'
});
l.log( 'aa\nbb' );
/* console prints
aa
bb
*/
```
##### Example #3
```javascript
/*Console as input for wLoggerToJstructure*/
var l = new wLoggerToJstructure
({
  outputPath : '/out3.txt'
});
l.inputFrom( console );
console.log( 'aa\nbb' );
```
