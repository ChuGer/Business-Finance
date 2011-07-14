<html>
    <head>
        <title>Welcome to Grails</title>
        <meta name="layout" content="main" />
        <style type="text/css" media="screen">

        #nav {
            margin-top:20px;
            margin-left:30px;
            width:228px;
            float:left;

        }
        .homePagePanel * {
            margin:0px;
        }
        .homePagePanel .panelBody ul {
            list-style-type:none;
            margin-bottom:10px;
        }
        .homePagePanel .panelBody h1 {
            text-transform:uppercase;
            font-size:1.1em;
            margin-bottom:10px;
        }
        .homePagePanel .panelBody {
            background: url(images/leftnav_midstretch.png) repeat-y top;
            margin:0px;
            padding:15px;
        }
        .homePagePanel .panelBtm {
            background: url(images/leftnav_btm.png) no-repeat top;
            height:20px;
            margin:0px;
        }

        .homePagePanel .panelTop {
            background: url(images/leftnav_top.png) no-repeat top;
            height:11px;
            margin:0px;
        }
        h2 {
            margin-top:15px;
            margin-bottom:15px;
            font-size:1.2em;
        }
        #pageBody {
            margin-left:280px;
            margin-right:20px;
        }
        </style>
  %{--<script type="text/javascript" src="js/jquery/jquery-1.4.2.js"></script>--}%
  %{--<script type="text/javascript" src="js/jquery/jquery-ui-1.8.1.min.js"></script>--}%

      %{--<script type="text/javascript" src="http://static.jstree.com/v.1.0pre/jquery.js"></script>--}%

      %{--<script type="text/javascript" src="http://static.jstree.com/v.1.0pre/jquery.cookie.js"></script>--}%
%{--<script type="text/javascript" src="http://static.jstree.com/v.1.0pre/jquery.hotkeys.js"></script>--}%
%{--<script type="text/javascript" src="http://static.jstree.com/v.1.0pre/jquery.jstree.js"></script>--}%
            %{--<script type="text/javascript" src="js/jquery.jstree.js"></script>--}%
      %{--<script type="text/javascript" src="js/_lib/jquery.cookie.js"></script>--}%
      %{--<script type="text/javascript" src="js/_lib/jquery.hotkeys.js"></script>--}%
  <g:javascript library="jquery" plugin="jquery"/>
      <jsTree:resources />

          <script type="text/javascript">
      $(document).ready(function() {
         $('#hh').click(function() {
              alert('Пёс дерни.');
         });


        	$('#demo1').jstree({
		"json_data" : {
			"data" : [
				{
					"data" : "A node",
					"metadata" : { id : 23 },
					"children" : [ "Child 1", "A Child 2" ]
				},
				{
					"attr" : { "id" : "li.node.id1" },
					"data" : {
						"title" : "Long format demo",
						"attr" : { "href" : "#" }
					}
				}
			]
		},
		"plugins" : [ "themes", "checkbox", "json_data", "ui" ]
	}).bind("select_node.jstree", function (e, data) { alert(jQuery.data(data.rslt.obj[0], "jstree").id) });
     $.jstree._reference('#demo1').open_node("#A node"); ;
//            alert('Handler for .click() called.');
//});
            });

    </script>
    </head>
    <body>
     <div class="nav" id="hh">======click========</div>
     <div id="demo1" class="demo" style="height:100px;">
	%{--<ul>--}%
		%{--<li id="phtml_1">--}%
			%{--<a href="#">Root node 1</a>--}%
			%{--<ul>--}%
				%{--<li id="phtml_2">--}%

					%{--<a href="#">Child node 1</a>--}%
				%{--</li>--}%
				%{--<li id="phtml_3">--}%
					%{--<a href="#">Child node 2</a>--}%
				%{--</li>--}%
			%{--</ul>--}%
		%{--</li>--}%
		%{--<li id="phtml_4">--}%

			%{--<a href="#">Root node 2</a>--}%
		%{--</li>--}%
	%{--</ul>--}%
</div>
        <div id="nav">
            <div class="homePagePanel">
                <div class="panelTop"></div>
              <sec:ifNotLoggedIn>
              <form method="POST" action="${resource(file: 'j_spring_security_check')}">
                <table>
                  <tr>
                    <td>Username:</td><td><g:textField name="j_username"/></td>
                  </tr>
                  <tr>
                    <td>Password:</td><td><input name="j_password" type="password"/></td>
                  </tr>
                  <tr>
                    <td colspan="2"><g:submitButton name="login" value="Login"/></td>
                  </tr>
                  <tr>
                    <td colspan="2">try "qwe" or "asd" with "123"</td>
                  </tr>
                </table>
              </form>
               </sec:ifNotLoggedIn>


                <div class="panelBody">
                    <h1>Application Status</h1>
                    <ul>
                        <li>App version: <g:meta name="app.version"></g:meta></li>
                        <li>Grails version: <g:meta name="app.grails.version"></g:meta></li>
                        <li>Groovy version: ${org.codehaus.groovy.runtime.InvokerHelper.getVersion()}</li>
                        <li>JVM version: ${System.getProperty('java.version')}</li>
                        <li>Controllers: ${grailsApplication.controllerClasses.size()}</li>
                        <li>Domains: ${grailsApplication.domainClasses.size()}</li>
                        <li>Services: ${grailsApplication.serviceClasses.size()}</li>
                        <li>Tag Libraries: ${grailsApplication.tagLibClasses.size()}</li>
                    </ul>
                    <h1>Installed Plugins</h1>
                    <ul>
                        <g:set var="pluginManager"
                               value="${applicationContext.getBean('pluginManager')}"></g:set>

                        <g:each var="plugin" in="${pluginManager.allPlugins}">
                            <li>${plugin.name} - ${plugin.version}</li>
                        </g:each>

                    </ul>
                </div>
                <div class="panelBtm"></div>
            </div>
        </div>
        <div id="pageBody">
            <h1>Welcome to Grails</h1>
            <p>Congratulations, you have successfully started your first Grails application! At the moment
            this is the default page, feel free to modify it to either redirect to a controller or display whatever
            content you may choose. Below is a list of controllers that are currently deployed in this application,
            click on each to execute its default action:</p>

            <div id="controllerList" class="dialog">
                <h2>Available Controllers:</h2>
                <ul>
                    <g:each var="c" in="${grailsApplication.controllerClasses.sort { it.fullName } }">
                        <li class="controller"><g:link controller="${c.logicalPropertyName}">${c.fullName}</g:link></li>
                    </g:each>
                </ul>
            </div>
        </div>
    </body>
</html>
