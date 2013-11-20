(function($, window, document) {
	"use strict";

	App.Lightbox = (function () {

		var lightBox,
			content,
			wrapper;

		function init() {
			lightBox = $('#lightbox');
			wrapper = $('#lightbox-wrapper');
			content = $('#lightbox-content');

			lightBox.click(hide);
		}

		function show()  {
			lightBox.fadeIn();
			wrapper.fadeIn();
		}

		function hide() {
			lightBox.fadeOut();
			wrapper.fadeOut();
		}

		function fill(data) {
			content.html(data);
		}

		return {
			init : init,
			show : show,
			hide : hide,
			fill : fill
		};

	})();

}(jQuery, this, this.document));