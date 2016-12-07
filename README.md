
## wLoggerToFile
Module in JavaScript providing convenient, layered, logging into file.
Logger that writes messages( incoming & outgoing ) to file specified by path( outputPath ).
Writes each message to the end of file, creates new file( outputPath ) if it doesn't exists.
Then transfers message to the next output(s) object in the chain if any exists.

## Installation
```terminal
npm install wLoggerToFile
```
## Usage
### Options
* outputPath { string }[ optional ] - output file path, default dirname/output.log.
* output { object }[ optional ] - output object for current logger, null by default.

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
/* Logging to a file */
var l = new wLoggerToFile();
l.log( 'aa\nbb' );
/* output.log gets
aa
bb
*/

```
##### Example #2
```javascript
/* Add console as output and pass custom output path */
var l = new wLoggerToFile
({
  output : console,
  outputPath : 'out2.txt'
});
l.log( 'aa\nbb' );
/* console and out2.txt get
aa
bb
*/
```
##### Example #3
```javascript
/* Console as input for wLoggerToFile to store console output into file */
var l = new wLoggerToFile();
l.inputFrom( console );
console.log( 'aa\nbb' );
/* save console output into file, message by message */
```






