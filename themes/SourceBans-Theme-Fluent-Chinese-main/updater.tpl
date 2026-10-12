<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>更新程序 | SourceBans++</title>
        <link rel="Shortcut Icon" href="../themes/default/images/favicon.ico" />
        <link href="../themes/default/css/main.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <div id="header">
            <div id="head-logo">
                <a href="index.php"><img src="../images/logos/sb-large.png" border="0" alt="SourceBans 标志" /></a>
            </div>
        </div>
        <div id="tabsWrapper"></div>
        <div id="mainwrapper">
            <div id="content_title" style="padding: 1rem 0rem"><b>更新程序</b></div>
            <div id="content">
                <h3>正在更新...</h3>
                {foreach from=$updates item="update"}
                    <ul style="font-size: 13px">{$update}</ul>
                {/foreach}
            </div>
        </div>
        <div id="footer">
            <div id="mainwrapper" style="text-align: center;">
    			<a href="https://github.com/sbpp/sourcebans-pp" target="_blank"><img src="../images/logos/sb.png" alt="SourceBans++" border="0" /></a><br/>
    			<span style="line-height: 20px;"><a style="color: #C1C1C1" href="https://github.com/sbpp/sourcebans-pp" target="_blank">SourceBans++</a></span><br/>
    			<span style="line-height: 20px;">由 <a href="http://www.sourcemod.net" target="_blank" style="color: #C1C1C1">SourceMod</a> 提供支持</span><br/>
    		    <span style="line-height: 20px;">&copy; 2024-2026 <a style="color: #C1C1C1" href="https://github.com/wenyinos/SourceBans-Theme-Fluent-Chinese" target="_blank">Fluent Chinese Theme</a>. 版权所有。</span>
    		</div>
    	</div>
    </body>
</html>
