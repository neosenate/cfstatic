<cfcomponent extends="mxunit.framework.TestCase" output="false">

<!--- setup, teardown, etc --->
	<cffunction name="setup" access="public" returntype="void" output="false">
		<cfscript>
			super.setup();
			cfstatic = createObject('component', 'org.cfstatic.CfStatic');
		</cfscript>	
	</cffunction>

	<cffunction name="teardown" access="public" returntype="void" output="false">
		super.teardown();
		cfstatic = "";
	</cffunction>

<!--- tests --->
	<cffunction name="t01_cfstatic_shouldThrowError_whenMixedMediaInPackage" returntype="void">
		<cfscript>
			var failed = false;
			
			cfstatic.init(
				  staticDirectory = _getResourcePath() & 'badFiles/mixedMediaInPackage/'
				, staticUrl       = "/any/old/thing"
				, minifyMode      = "package"
			);
						
			try {
				cfstatic.renderIncludes();
				
			} catch ( "cfstatic.Package.badConfig" e ) {
				failed = true;
			}			
			
			Assert(failed);
		</cfscript>	
	</cffunction>
	
	<cffunction name="t02_cfstatic_shouldThrowError_whenMixedIeConstraintInPackage" returntype="void">
		<cfscript>
			var failed = false;
			
			cfstatic.init(
				  staticDirectory = _getResourcePath() & 'badFiles/mixedIeInPackage/'
				, staticUrl       = "/any/old/thing"
				, minifyMode      = "package"
			);
			try {
				cfstatic.renderIncludes();
				
			} catch ( "cfstatic.Package.badConfig" e ) {
				failed = true;
			}			
			
			Assert(failed);
		</cfscript>	
	</cffunction>

	<cffunction name="t03_cfstatic_shouldThrowError_whenMixedMediaAndUsingMinifyAllMode" returntype="void">
		<cfscript>
			var failed = false;
			
			cfstatic.init(
				  staticDirectory = _getResourcePath() & 'badFiles/mixedMediaInAll/'
				, staticUrl       = "/any/old/thing"
				, minifyMode      = "all"
			);
			
			try {
				cfstatic.renderIncludes();
			} catch ( "cfstatic.PackageCollection.badConfig" e ) {
				failed = true;
			}				
			Assert(failed);
			
		</cfscript>	
	</cffunction>
	
	<cffunction name="t04_cfstatic_shouldThrowError_whenMixedIeConstraintAndUsingMinifyAllMode" returntype="void">
		<cfscript>
			var failed = false;
			
			cfstatic.init(
				  staticDirectory = _getResourcePath() & 'badFiles/mixedIeInAll/'
				, staticUrl       = "/any/old/thing"
				, minifyMode      = "all"
			);
			
			try {
				cfstatic.renderIncludes();
				
			} catch ( "cfstatic.PackageCollection.badConfig" e ) {
				failed = true;
			}			
			
			Assert(failed);
		</cfscript>	
	</cffunction>

	<cffunction name="t05_cfstatic_shouldThrowError_whenCompilingBadJavaScript" returntype="void">
		<cfscript>
			var failed = false;
			
			try {
				cfstatic.init(
					  staticDirectory = _getResourcePath() & 'badFiles/badJavaScript/'
					, staticUrl       = "/any/old/thing"
				);
							
			} catch ( "org.cfstatic.util.YuiCompressor.badJs" e ) {
				failed = true;

				AssertEquals("There was an error compressing your javascript: 'Error at line 10 (char 18): syntax error'. Please see the error detail for the problematic javascript source.", e.message);
			}			
			
			Assert(failed);
		</cfscript>	
	</cffunction>

	<cffunction name="t06_cfstatic_shouldThrowError_whenMissingDependencies" returntype="void">
		<cfscript>
			var failed = false;
			
			try {
				cfstatic.init(
					  staticDirectory = _getResourcePath() & 'badFiles/missingDependencies/'
					, staticUrl       = "/any/old/thing"
				);
			} catch ( "org.cfstatic.missingDependency" e ) {
				failed = true;

				AssertEquals("CFStatic Error: Could not find local dependency.", e.message);
				Assert(find("The dependency, '/core/layout.less', could not be found or downloaded.", e.detail) EQ 1);
				Assert(find("/css/other/somePage.less.css", e.detail));
			}			
			
			Assert(failed);		</cfscript>	
	</cffunction>

<!--- private --->
	<cffunction name="_getResourcePath" access="private" returntype="string" output="false">
		<cfreturn '/tests/integration/resources/' />
	</cffunction>
</cfcomponent>