/**
 * Script used by gallary view
 */


var overlayOpacity = 0.8;	// controls transparency of shadow overlay
var overlayDuration = 0.2;

Object.extend(Element, {
	getWidth: function(element) {
	   	element = $(element);
	   	return element.offsetWidth; 
	},
	setWidth: function(element,w) {
	   	element = $(element);
    	element.style.width = w +"px";
	},
	setHeight: function(element,h) {
   		element = $(element);
    	element.style.height = h +"px";
	},
	setTop: function(element,t) {
	   	element = $(element);
    	element.style.top = t +"px";
	},
	setSrc: function(element,src) {
    	element = $(element);
    	element.src = src; 
	},
	setHref: function(element,href) {
    	element = $(element);
    	element.href = href; 
	},
	setInnerHTML: function(element,content) {
		element = $(element);
		element.innerHTML = content;
	}
});

var GallaryPassbox = Class.create();

GallaryPassbox.prototype = {

  initialize: function() {
		if (!document.getElementsByTagName){ return; }
		var anchors = document.getElementsByTagName('a');
		var areas = document.getElementsByTagName('area');

		// loop through all anchor tags
		for (var i=0; i<anchors.length; i++){
			var anchor = anchors[i];
			
			var relAttribute = String(anchor.getAttribute('rel'));
			
			// use the string.match() method to catch 'lightbox' references in the rel attribute
			if (anchor.getAttribute('href') && (relAttribute.toLowerCase().match('pass_box'))){
				//anchor.onclick = function () {passBox.show_box(this); return false;}
			}
		}

		for (var i=0; i< areas.length; i++){
			var area = areas[i];
			
			var relAttribute = String(area.getAttribute('rel'));
			
			// use the string.match() method to catch 'lightbox' references in the rel attribute
			if (area.getAttribute('href') && (relAttribute.toLowerCase().match('pass_box'))){
				//area.onclick = function () {passBox.show_box(this); return false;}
			}
		}
		
		var objBody = document.getElementsByTagName("body").item(0);
		var objOverlay = document.createElement("div");
		objOverlay.setAttribute('id','passbox_overlay');
		objOverlay.style.display = 'none';
		objBody.appendChild(objOverlay);

    var objBox;
    if (!$('passbox')) {
      objBox = document.createElement("div");
		  objBox.setAttribute('id','passbox');
    } else {
      objBox = $('passbox');
    }
		objBox.style.display = 'none';
		objBody.appendChild(objBox);

    //var objForm = document.getElementsByTagName("form").item(1);
    var objForm = $$('#passbox > form')[0];
    if(!objForm) { return; }
    var objInfo = document.createElement("span");
    objInfo.setAttribute('id', 'box_message');
    objForm.appendChild(objInfo);
    
    var objLabel = document.createElement("span");
    objLabel.setAttribute('id', 'label');
    objLabel.innerHTML = "Password";
    objForm.appendChild(objLabel);
    
    /*
    var objInput = document.createElement("input");
    objInput.setAttribute('id', 'password');
    objInput.setAttribute('type', 'text');
    objBox.appendChild(objInput);
    */
    var objId= document.createElement("input");
    objId.setAttribute('id', 'passbox_id');
    objId.setAttribute('type', 'hidden');
    objId.setAttribute('name', 'passbox[id]');
    objForm.appendChild(objId);

    var objSubmit = document.createElement("input");
    objSubmit.setAttribute('type', 'submit');
    objSubmit.setAttribute('value', 'Post');
    objSubmit.setAttribute('name', 'commit');
    objForm.appendChild(objSubmit);

    var objClose = document.createElement("input");
    objClose.setAttribute('type', 'button');
    objClose.setAttribute('value', 'Close');
    objClose.setAttribute('onclick', 'passBox.hide_box()');
    objForm.appendChild(objClose);

  },
  
  show_box: function(subject) {
    if ($('passbox_id')) {
      $('passbox_id').value = subject;
    }
    var arrayPageSize = getPSize();
    Element.setHeight('passbox_overlay', arrayPageSize[1]);
    Effect.Appear('passbox_overlay', { duration: overlayDuration, from: 0.0, to: overlayOpacity });

    var arrayPageScroll = getPScroll();
    var boxTop = arrayPageScroll[1] + (arrayPageSize[3] / 10);
    Element.setTop('gallary_password', boxTop);
    Element.show('gallary_password');

    Element.setTop('passbox', boxTop);
    Element.show('passbox');
  },

  hide_box: function() {
    $('gallary_password').hide();
    $('passbox').hide();
		new Effect.Fade('passbox_overlay', { duration: overlayDuration });
  }
}

function getPScroll(){
  var yScroll;

  if (self.pageYOffset) {
    yScroll = self.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
    yScroll = document.documentElement.scrollTop;
  } else if (document.body) {// all other Explorers
    yScroll = document.body.scrollTop;
  }

  arrayPageScroll = new Array('',yScroll) 
  return arrayPageScroll;
}

function getPSize(){
	var xScroll, yScroll;
	
	if (window.innerHeight && window.scrollMaxY) {	
		xScroll = document.body.scrollWidth;
		yScroll = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
		xScroll = document.body.scrollWidth;
		yScroll = document.body.scrollHeight;
	} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
		xScroll = document.body.offsetWidth;
		yScroll = document.body.offsetHeight;
	}
	
	var windowWidth, windowHeight;
	if (self.innerHeight) {	// all except Explorer
		windowWidth = self.innerWidth;
		windowHeight = self.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
		windowWidth = document.documentElement.clientWidth;
		windowHeight = document.documentElement.clientHeight;
	} else if (document.body) { // other Explorers
		windowWidth = document.body.clientWidth;
		windowHeight = document.body.clientHeight;
	}	
	
	// for small pages with total height less then height of the viewport
	if(yScroll < windowHeight){
		pageHeight = windowHeight;
	} else { 
		pageHeight = yScroll;
	}

	// for small pages with total width less then width of the viewport
	if(xScroll < windowWidth){	
		pageWidth = windowWidth;
	} else {
		pageWidth = xScroll;
	}

	arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight) 
	return arrayPageSize;
}

function initGallaryPassbox() { passBox = new GallaryPassbox(); }
Event.observe(window, 'load', initGallaryPassbox, false);
