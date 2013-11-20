(function($, window, document) {
	"use strict";

	var Dashboard = (function () {

		var active,
			activeTab,
			tasksTab,
			loader,
			loaderCounter = 0,
			loaderLimit = 10000,
			newStudentForm,
			reviewStudents,
			reviewPurchases,
			unresolvedLessons,
			newStudentLink,
			newPurchaseLink,
			newLessonLink;

		function init() {
			
			// Locals
			tasksTab = $('.task');
			active = $('.task.active');
			activeTab = active.attr('meta-tab');
			newStudentForm = $('#new_student');
			reviewStudents = $('#review-students');
			reviewPurchases = $('#review-purchases');
			unresolvedLessons = $('#unresolved');
			newStudentLink = $('#new-student-link');
			newPurchaseLink = $("#new-purchase-link");
			newLessonLink = $('#new-lesson-link');


			// Events
			tasksTab.click(switchTask);
			newStudentLink.click(newStudentBox);
			newPurchaseLink.click(newPurchaseBox);
			newLessonLink.click(newLessonBox);

			// Load Content Initially
			loadStudentData();
			loadPurchaseData();
			loadUnresolvedLessons();
		}

		function switchTask() {
			if(!$(this).hasClass('active')) {
				$('.task.active').removeClass('active');
				$(this).addClass('active');

				// Now set new task
				var metaTab = $('.task.active').attr('meta-tab');
				$('#' + activeTab).fadeOut();
				$('#' + metaTab).fadeIn();
				activeTab = metaTab;

				if (!$('#'+activeTab).hasClass('loaded')) {
					$('#'+activeTab + ' .loader').show();
				} else {
					$('#'+activeTab + ' .loader').hide();
				}
			}
		}

		function loadStudentData() {
			if (reviewStudents.size() > 0) {
				reviewStudents.find('.form-error').html('');
				reviewStudents.removeClass('loaded');
				$.ajax({
					type : "GET",
					url : "/reviewstudents",
					dataType: 'text'
				}).done(function (responseText) {
					reviewStudents.find('.inner').html(responseText);
					reviewStudents.addClass('loaded');
				}).fail(function (data) { 
					reviewStudents.find('.form-error').html('An error occurred retrieving your students.');
					reviewStudents.addClass('loaded');			
				});
			}
		}

		function loadPurchaseData() {
			if (reviewPurchases.size() > 0) {
				reviewPurchases.find('.form-error').html('');
				reviewPurchases.removeClass('loaded');
				$.ajax({
					type : "GET",
					url : "/reviewpurchases",
					dataType: 'text'
				}).done(function (responseText) {
					reviewPurchases.find('.inner').html(responseText);
					reviewPurchases.addClass('loaded');
					App.Purchases.applyPurchaseClick();
				}).fail(function (data) { 
					reviewPurchases.find('.form-error').html('An error occurred retrieving your students.');
					reviewPurchases.addClass('loaded');			
				});
			}
		}

		function loadUnresolvedLessons() {
			if (unresolvedLessons.size() > 0) {
				unresolvedLessons.find('.form-error').html('');
				unresolvedLessons.removeClass('loaded');
				$.ajax({
					type : "GET",
					url : "/getunresolvedlessons",
					dataType: 'text'
				}).done(function (responseText) {
					unresolvedLessons.find('.inner').html(responseText);
					unresolvedLessons.addClass('loaded');
				}).fail(function (data) { 
					unresolvedLessons.find('.form-error').html('An error occurred retrieving your students.');
					unresolvedLessons.addClass('loaded');			
				});
			}
		}

		function newStudentBox() {
			if (newStudentLink.size() > 0) {
				$.ajax({
					type : "GET",
					url : "/students/new",
					dataType: 'text'
				}).done(function (responseText) {
					App.Lightbox.fill(responseText);
					App.Lightbox.show();
					App.Form.init();
				}).fail(function (data) { 
					App.Lightbox.fill("An error occurred attempting to retrieve this form.");
					App.Lightbox.show();
				});
			}
		}

		function newPurchaseBox() {
			if (newPurchaseLink.size() > 0) {
				$.ajax({
					type : "GET",
					url : "/purchases/new",
					dataType: 'text'
				}).done(function (responseText) {
					App.Lightbox.fill(responseText);
					App.Lightbox.show();
					App.Form.init();
				}).fail(function (data) { 
					App.Lightbox.fill("An error occurred attempting to retrieve this form.");
					App.Lightbox.show();
				});
			}
		}

		function newLessonBox() {
			if (newLessonLink.size() > 0) {
				$.ajax({
					type : "GET",
					url : "/lessons/new",
					dataType: 'text'
				}).done(function (responseText) {
					App.Lightbox.fill(responseText);
					App.Lightbox.show();
					App.Form.init();
				}).fail(function (data) { 
					App.Lightbox.fill("An error occurred attempting to retrieve this form.");
					App.Lightbox.show();
				});
			}
		}		
		return {
			init : init,
			loadStudentData : loadStudentData,
			loadPurchaseData : loadPurchaseData
		};

	})();

	App.Dashboard = Dashboard;


}(jQuery, this, this.document));