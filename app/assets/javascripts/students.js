(function($, window, document) {
	"use strict";

	/**
	*	Form Handlers
	**/
	new App.FormResponse('new_student', 
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>New Student Created</div>");
			success.fadeIn('fast');
			setTimeout(function () {
				success.fadeOut(500, function () {
					success.html('');
				});

			}, 1500);
			App.Dashboard.loadStudentData();
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

	new App.FormResponse('edit_student',
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>Student Updated!</div>");
			var newName = $('#student_name').val();
			$('#page-title').text('Edit ' + newName);
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