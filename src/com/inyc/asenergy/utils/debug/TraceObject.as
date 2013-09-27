package com.inyc.asenergy.utils.debug {
	import flash.xml.XMLNode;			

	public class TraceObject extends Object {
		
		static private var $tabs: String;
		
		function TraceObject():void{
		}
		
		public static function DUMP( obj:Object, outerChar:String=null, initialBlockDisplayed:Boolean=false, results:String=null ) : String {
			if ( obj == null )
				return null;
			
			if ( ( obj ) is XML || ( obj ) is XMLNode ) {	
				return obj.toString();
			}
			
			if ( results == null ) {
				results = "";
				$tabs = "";
			}
			
			// if the variable we are tracing isn't an object, we can just
			// call the regular trace command and bail out.
			if ( typeof( obj ) != "object" ) {
				results += $tabs + outerChar + "\n";
				
				return results;
			}
	
			if ( $tabs == null ) {
				$tabs = "";
			}
			
			// default the "outer character" of a container to be "{"
			// -- the only other choice here is "["
			if ( outerChar == null ) {
				if (  typeof( obj.pop ) == "function" )
				{
					outerChar = "[";
				}
				else
				{
					outerChar = "{";
				}
			}
		
			// initial block is used to signify if the outer character
			// has already been printed to the screen.
			if ( initialBlockDisplayed != true ) {
				results += $tabs + outerChar + "\n";  
			}
		
			// every time this function is called we'll add another
			// tab to the indention in the output window
			$tabs += "\t";
			
			// loop through everything in the object we're tracing
			for ( var i:String in obj ) {
				var type:String = typeof( obj[i] );
				// determine what's inside...
				if( type == "object" ) {
					// the variable is another container
					// check to see if the variable is an array.  Arrays
					// have a "pop" method, and objects don't...
					try 
					{
					if ( typeof( obj[i].pop ) == "function" ) {
						// if an array, use the "[" as the outer character
						results += $tabs + i + ": [" + "\n";
						
						// recursive call
						results = DUMP( obj[i], "[", true, results );
					} else if ( ( obj[i] ) is Date ) {
						results += $tabs + i + ": {" + obj[i] + "}" + "\n";
					} else if ( ( obj[i] ) is XML ) {
						results += $tabs + i + ": {" + "\n" + obj[i].toString() + "\n" + "}" + "\n";
					} else {
						results += $tabs + i + ": {" + "\n";
						// recursive call
						results = DUMP( obj[i], "{", true, results );
					}
					}
					catch ( e:Error )
					{
						results += $tabs + i + ": " + obj[i] + "" + "\n";
					}
				} else if ( type == "string" ) {
					// display quotes
					results += $tabs + i + ": \"" + obj[i] + "\"" + "\n";
				} else {
					//variable is not an object or string, just trace it out normally
					if ( obj[i] == null ) {
						results += $tabs + i + ": null" + "\n";
					} else {
						results += $tabs + i + ": " + obj[i] + "\n";
					}
				}
			}
			// here we need to displaying the closing '}' or ']', so we bring
			// the indent back a tab, and set the outerchar to be it's matching
			// closing char, then display it in the output window
			if ( outerChar == "{" ) {
				outerChar = "}";
			} else {
				outerChar = "]";
			}
			$tabs = $tabs.substr(0, $tabs.length - 1);
			
			results += $tabs + "" + outerChar + "\n";
			
			return results;
		}
		
	}
}
