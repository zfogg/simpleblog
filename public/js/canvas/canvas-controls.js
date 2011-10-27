function CanvasControls() {
    var controls = document.getElementById("canvas-controls");

    function newControlDiv(id) {
        var div = document.createElement('div');
        if (id) div.id = id;
        controls.appendChild(div);
        return div
    }

    function inputElement(type, defaultValue) {
        var input = document.createElement('input');
        input.type = type, input.value = defaultValue;
        return input;
    }

    function pElement(text) {
        var p = document.createElement('p');
        p.innerHTML = text;
        return p;
    }

    this.NumberInput = function(name, defaultValue, eventType, event) {
        var numberInput = inputElement("number", defaultValue);
        if (event) numberInput[eventType] = event;

        numberInput.reset = function() {
            this.value = defaultValue;
            if (this.onchange) this.onchange();
        };

        controls.appendChild(pElement(name));
        controls.appendChild(numberInput);

        return numberInput;
    };

    this.ButtonInput = function(name, eventType, event) {
        var button = inputElement("button", name);
        controls.appendChild(button);
        button.setAttribute("style", "width: " + name.width);

        if (event)
            button[eventType] = event;
        
        return button;
    };

    this.controlLimit = function(limit) {
        return function(e) {
            this.value = Math.clipValues(this.value, limit.lower, limit.upper);
        };
    };

    this.propertyUpdater = function(obj, objProperty, modifier) {
        return function() {
            obj[objProperty] = this.value / (modifier || 1);
        };
    };

    this.children = function() {
        return $("#canvas-controls").children();
    };
    
    $(document).ready(function () {
    	$("#canvas-controls-container").show();
	    $("#toggle-menu a").mousedown(function(event) {
	    	if (event.which === 1) {
	            $("#canvas-controls").slideToggle('slow');
	            $("#toggle-menu a").text(
	                $("#toggle-menu a").text().indexOf("Show") != -1 ? "Hide" : "Show"
	        	);
        	}
	    });
	});
}
