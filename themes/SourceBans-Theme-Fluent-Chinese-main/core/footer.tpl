	<!-- </div> -->
	</div>
	</main>
	<footer class="footer">
	  <div class="layout_container flex flex-jc:space-between flex-ai:center">
	    <div class="flex flex-fd:column text:left">
	      <a href="https://sbpp.github.io/" target="_blank" rel="noopener">SourceBans++ | {$version}{$git}</a>
	      <span>由 <a href="https://www.sourcemod.net" target="_blank" rel="noopener">SourceMod</a> 提供支持</span>
	      <span><i class="fas fa-code"></i> <a href="https://github.com/Rushaway/sourcebans-web-theme-fluent" title="Theme Fluent for SourceBans++" target="_blank" rel="noopener">Fluent 主题</a> 由 <a href="https://axendev.net/" title="Theme by aXenDev" target="_blank" rel="noopener">aXenDev</a> 原创</span>
	    </div>
	    <div class="flex flex-fd:column text:right">
	      <span>汉化<a href="https://github.com/wenyinos/SourceBans-Theme-Fluent-Chinese" target="_blank" rel="noopener">wenyinos</a></span>
		  <span>感谢<a href="https://github.com/F1F88" target="_blank" rel="noopener">F1F88</a></span>
	    </div>
	  </div>
	</footer>

	<script type="text/javascript" src="themes/{$theme}/scripts/nav.js"></script>
	<script type="text/javascript" src="themes/{$theme}/scripts/jscolor.min.js"></script>
	<script type="text/javascript" src="themes/{$theme}/scripts/theme.js"></script>

	<script>
	  {$query}

	  {literal}
  	  window.addEvent('domready', function() {

  	    ProcessAdminTabs();

  	    var Tips2 = new Tips($('.tip'), {
  	      initialize: function() {
  	        this.fx = new Fx.Style(this.toolTip, 'opacity', {duration: 300, wait: false}).set(0);
  	      },
  	      onShow: function(toolTip) {
  	        this.fx.start(1);
  	      },
  	      onHide: function(toolTip) {
  	        this.fx.start(0);
  	      }
  	    });
  	    var Tips4 = new Tips($('.perm'), {
  	      className: 'perm'
  	    });
  	  });
	  {/literal}
	</script>
	</body>

	</html>
