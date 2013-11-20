(function($, window, document) {
	"use strict";

	new App.FormResponse('new_contact', 
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>New Contact Created</div>");
			success.fadeIn('fast');
			setTimeout(function () {
				success.fadeOut(500, function () {
					success.html('');
				});

			}, 1500);
		},
		function (data) {
			var error = $('#' + this.id).find('.form-error');
			error.html('<div>'+ data.message +'</div>');
			error.fadeIn();
			setTimeout(function () {
				error.fadeOut(500, function () {
					error.html('');
				});
			}, 1500);
		}
	);

	new App.FormResponse('edit_contact', 
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>Contact Updated</div>");
			success.fadeIn('fast');
			setTimeout(function () {
				success.fadeOut(500, function () {
					success.html('');
				});

			}, 1500);
		},
		function (data) {
			var error = $('#' + this.id).find('.form-error');
			error.html('<div>'+ data.message +'</div>');
			error.fadeIn();
			setTimeout(function () {
				error.fadeOut(500, function () {
					error.html('');
				});
			}, 1500);
		},
		['edit']
	);

}(jQuery, this, this.document));