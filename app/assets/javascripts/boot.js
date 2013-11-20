//-------------------------------------------------------------/

(function($, window, document) {
	"use strict";

	App.bootstrap = function () {
		App.Global.init();
		App.Notify.init();
		App.Dashboard.init();
		App.Form.init();
		App.Purchases.init();
		App.Lessons.init();
		App.Lightbox.init();
	};

}(jQuery, this, this.document));