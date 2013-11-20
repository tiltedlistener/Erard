//-------------------------------------------------------------/

(function($, window, document) {
	"use strict";

	var Notify = (function () {

		var form,
			formWrapper,
			loginWrapper;

		function init() {
			form = $('#remote_notify');
			formWrapper = $('#notify-after-beta');
			loginWrapper = $('#login-wrapper');
			form.bind('ajax:success', function(evt, data, status, xhr){
			    notifySuccess(data);
			});
		}

		function notifySuccess(data) {
			if(data.table.result) {
				alert("Thank you! We will notify you soon.");
				formWrapper.slideUp();
				loginWrapper.animate({'width' : '120%'},1000);

			} else {
				alert(data.table.message);
			}
		}

		return {
			init : init,
		}

	})();

	App.Notify = Notify;

}(jQuery, this, this.document));