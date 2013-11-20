(function($, window, document) {
	"use strict";

	/**
	*	Response Class
	*
	*	Use for creating the ajax response to take these events out of modules.
	**/
	App.FormResponse = function (id, logic, error, flags) {
		
		try {
			this.id = id;
		} catch(err) {
			console.log(err.message);
		}

		this.successLogic = logic || function () {};
		this.errorLogic = error || function () {};

		if (typeof flags != 'undefined' && flags.length > 0)
			this.flags = flags;

		var t = this;

		/*
		*	Main Callback that triggers on success. Additional nuanced error response handling runs through here
		*/
		this.callback = function(evt, data, status, xhr){
			if (data.status == 'ok') {
				$('#' + this.id).removeClass('form-processing');
				$('#' + this.id).find('.form-loader').hide();
				$('#' + this.id).find('input[type="submit"]')[0].disabled = false;
				$('#' + this.id).find('input[type="submit"]').removeClass('form-submit-processing'); 
				t.successLogic(data);

				if ($.inArray('edit',t.flags) == -1)
					document.getElementById(this.id).reset();
			} else {
				t.formatError(data);
			}
		};

		/*
		*	Error for more casual formatting errors
		*/
		this.formatError = function(data) {
			$('#' + this.id).removeClass('form-processing');
			$('#' + this.id).find('.form-loader').hide();
			$('#' + this.id).find('input[type="submit"]')[0].disabled = false;
			$('#' + this.id).find('input[type="submit"]').removeClass('form-submit-processing');
			t.errorLogic(data);
		};

		/*
		*	For full AJAX or 500 errors. Not for form submission checks
		*/
		this.error = function(xhr, data, status) {
			$('#' + this.id).find('.form-loader').hide();
			$('#' + this.id).find('input[type="submit"]').removeClass('form-submit-processing'); 
			$('#' + this.id).find('.form-error').html('<div>An error occured processing your form. Please try again later.</div>');
			$('#' + this.id).find('.form-error').fadeIn();
		};

		App.Form.addSuccessCallback(this);
		App.Form.addErrorCallback(this);
	};


	/**
	*	Form Manager
	**/
	App.Form = (function () {

		var Forms,
			Tests = {},
			Errors = [],
			formTypes = [
				'textarea',
				'input[type="text"]',
				'input[type="radio"]',
				'input[type="checkbox"]',
				'input[type="tel"]',
				'input[type="email"]',
				'input[type="number"]',
				'select'
			],
			formTypesLen = formTypes.length,
			successCallbacks = [],
			errorCallbacks = [];

		function init() {
			attachForms();
			buildSuccessCallbacks();
			buildErrorCallbacks();
		}

		/*
		*	Attaches standard behaviors to all the forms on a page.
		*/
		function attachForms() {
			Forms = $('form');

			Forms.each(function () {
				$(this).submit(standardSubmit);
			});
		}

		function buildSuccessCallbacks() {
			var len = successCallbacks.length;
			for(var i=0;i<len;i++) {
				var current = successCallbacks[i];
				$('#' + current.id).bind('ajax:success', current.callback);
			}
		}

		function buildErrorCallbacks() {
			var len = errorCallbacks.length;
			for(var i=0;i<len;i++) {
				var current = errorCallbacks[i];
				$('#' + current.id).bind('ajax:error', current.error);
			}
		}


		function standardSubmit() {
			
			// Clear Errors
			$(this).find('.form-error').hide();
			$(this).find('.field-error').removeClass('field-error');
			$(this).find('.field-error-message').remove();

			// Process response
			$(this).addClass('form-processing');
			$(this).find('.form-loader').show();
			$(this).find('input[type="submit"]')[0].disabled = true;
			$(this).find('input[type="submit"]').addClass('form-submit-processing');

			if(!runTests(this)) {
				// formError(this);
				$(this).removeClass('form-processing');
				$(this).find('input[type="submit"]')[0].disabled = false;
				$(this).find('input[type="submit"]').removeClass('form-submit-processing'); 				
				$(this).find('.form-loader').hide();
				return false;
			}
		}

		function formError(form) {
			var errorSpot = $(form).find('.form-error'),
				len = Errors.length;
			for(var i=0;i<len;i++) {
				var text = Errors[i];
				errorSpot.append('<div class="field-error-message">' + text  + '</div>');
			}
			errorSpot.fadeIn();
		}

		function addTest(test) {
			if (typeof Tests[test.type] == 'undefined')
				Tests[test.type] = [];

			Tests[test.type].push(test);
		}

		function runTests(form) {

			// Clear Errors
			Errors = [];

			// Get all inputs to check
			var Inputs = [],
				formTypesCheck = Object.getOwnPropertyNames(Tests),
				testsLen = formTypesCheck.length;
			for (var tt = 0;tt<testsLen;tt++) {
				var cur = formTypesCheck[tt],
					result = $(form).find(cur);

				if (result.length > 0)
					Inputs.push(result);
			}

			var inputLen = Inputs.length;
			for(var j=0;j<inputLen;j++) {
				var cur = Inputs[j],
					curSize = cur.size(),
					selector = cur.selector,
					tests = Tests[selector];

				if (typeof tests !== 'undefined') {
					for(var z=0;z<curSize;z++) {
						var subCurrent = cur.eq(z),
							testLen = tests.length,
							exceptions = getExceptions(subCurrent);

						for (var q=0;q<testLen;q++) {
							var thisTest = tests[q],
								res = [];

						 	if ($.inArray(thisTest.name, exceptions) === -1) 
						 		res = thisTest.run(subCurrent.val());
						 	else
						 		res = [true];

							if (!res[0]) {
								Errors.push(res[1]);
								subCurrent.addClass('field-error');
								$(subCurrent).after('<div class="field-error-message">'+ res[1] +'</div>');
							}
						}
					}	
				}
			}

			if (Errors.length === 0)
				return true;
			else {
				return false;
			}
		}

		function getExceptions(obj) {
			var classes = obj.attr('class'),
				matches = [];

			if (typeof classes !== 'undefined') {
				var matches = classes.match(/exception-[a-zA-Z]+/gi);
				if (matches === null) {
					matches = [];
				} else {
					var len = matches.length;
					for (var i=0;i<len;i++) {
						matches[i] = matches[i].replace(/exception-/, '');
					}
				}
			}
			
			return matches;
		}

		function addSuccessCallback(obj) {
			successCallbacks.push(obj);
		}

		function addErrorCallback(obj) {
			errorCallbacks.push(obj);
		}

		return {
			init : init,
			attachForms : attachForms,
			formError : formError,
			addTest : addTest, 
			runTests : runTests,
			addSuccessCallback : addSuccessCallback,
			addErrorCallback : addErrorCallback
		};

	})();


}(jQuery, this, this.document));