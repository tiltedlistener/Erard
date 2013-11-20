(function($, window, document) {
	"use strict";

	/**
	*	Lessons module
	**/
	App.Lessons = (function () {

		var upcomingLessonsIndivual,
			upcomingLessonsAll;

		function init() {
			upcomingLessonsIndivual = $('#upcoming-lessons-individual');
			upcomingLessonsAll = $('#upcoming-lessons-all');

			// Standard run of lessons display
			getUpcomingLessonsIndivual();
			getUpcomingLessonsAll();
		}

		function getUpcomingLessonsAll() {
			if (upcomingLessonsAll.size() > 0) {
				$.ajax({
					type : "GET",
					url : "/getupcominglessonsall",
					data : {'id' : App.Page.ParamID},
					dataType: 'text'
				}).done(function (responseText) {
					upcomingLessonsAll.find('.inner').html(responseText);
					upcomingLessonsAll.addClass('loaded');
				}).fail(function (data) { 
					upcomingLessonsAll.find('.form-error').html('An error occurred retrieving your students.');
					upcomingLessonsAll.addClass('loaded');			
				});
			}
		}

		function getUpcomingLessonsIndivual() {
			if (upcomingLessonsIndivual.size() > 0) {
				$.ajax({
					type : "GET",
					url : "/getupcominglessons",
					data : {'id' : App.Page.ParamID},
					dataType: 'text'
				}).done(function (responseText) {
					upcomingLessonsIndivual.find('.inner').html(responseText);
					upcomingLessonsIndivual.addClass('loaded');
				}).fail(function (data) { 
					upcomingLessonsIndivual.find('.form-error').html('An error occurred retrieving your students.');
					upcomingLessonsIndivual.addClass('loaded');			
				});
			}
		}


		return {
			init : init,
			getUpcomingLessonsAll : getUpcomingLessonsAll
		};

	})();

	/**
	*	Form Handlers
	**/
	new App.FormResponse('new_lesson', 
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>New Lesson Scheduled</div>");
			success.fadeIn('fast');
			setTimeout(function () {
				success.fadeOut(500, function () {
					success.html('');
				});

			}, 1500);
			App.Lessons.getUpcomingLessonsAll();
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

	new App.FormResponse('edit_lesson', 
		function(data) {
			var success = $('#'+this.id).find('.form-success');
			success.append("<div>Lesson Updated</div>");
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