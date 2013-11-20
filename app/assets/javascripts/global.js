(function($, window, document) {
	"use strict";

	App.Global = (function () {

		var edits,
			hasEdits;

		function init() {

			edits = $('.edit');
			hasEdits = $('.has-edit');

			edits.click(switchToEdit);
			bindEdits();
		}

		function bindEdits() {
			hasEdits.hover(showEdit, hideEdit);
		}

		function switchToEdit() {
			var parent = $(this).parent();
			parent.find('.edit-region').show();
			parent.find('.edit').hide();
			parent.find('.static-content').hide();

			parent.unbind('mouseenter', showEdit);
			parent.unbind('mouseleave', hideEdit);
		}

		function showEdit() {
			$(this).find('.edit').fadeIn('fast');
		}

		function hideEdit() {
			$(this).find('.edit').fadeOut('fast');
		}

		return {
			init : init
		};

	})();

}(jQuery, this, this.document));