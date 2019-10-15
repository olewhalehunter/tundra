// Tundra Client JavaScript
//

var tipDown = false;
var tipMoving = false;
var windowWidth = window.innerWidth;
var windowHeight = window.innerHeight;
var guideToggled = true;

document.onmousemove = onTipMove;
document.onmousedown = onTipDown;

function onTipDown (event) {
    focusSquareTrim = 200;    
    deltaYaw = 0.3;    
    if (event.pageX > (windowWidth / 2.0) + focusSquareTrim){
	rotateYaw(deltaYaw); return; }
    
    if (event.pageX < (windowWidth / 2.0) - focusSquareTrim) {
	rotateYaw(deltaYaw * -1); return; }
    
    if (event.pageY > (windowHeight / 2.0) + focusSquareTrim){
	rotatePitch(deltaYaw); return; }
    
    if (event.pageY < (windowHeight / 2.0) - focusSquareTrim) {
	rotatePitch(deltaYaw * -1);
    }    
}

function onTipMove (event) {
    var eventDoc, doc, body;    
    event = event || window.event;
}


var programinfo;

function textureSelect (fileName, textureRef) {    
    var image = new Image();
    image.src = fileName;

    image.addEventListener('load', function() {    
	gl.bindTexture(gl.TEXTURE_2D, textureRef);
	gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA,gl.UNSIGNED_BYTE, image);    
	if (isPowerOf2(image.width) && isPowerOf2(image.height)) {       
	    gl.generateMipmap(gl.TEXTURE_2D);
	} else {       
	    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
	    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
	    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
	}
    });    
}

function colourSelect() {        
    gl.texImage2D(gl.TEXTURE_2D, 0,
		  gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE,
                  new Uint8Array([0, 0, 255, 255]));    
}

var cloudTexture;
var stoneTexture;
var inkTexture;
var barkTexture;
var dirtTexture; 
var leafTexture; 
var shadeTexture;
var commTexture;

var cTexture;
var dTexture;
var eTexture;
var fTexture;
var gTexture;
var aTexture;
var bTexture;


function TundraMain () {
    
    glcanvassetup();
    gl.enable(gl.BLEND);
    var texcoordBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);    

    cloudTexture = gl.createTexture();
    textureSelect("cloud.png", cloudTexture);
    stoneTexture = gl.createTexture();
    inkTexture = gl.createTexture();
    barkTexture = gl.createTexture();
    shadeTexture = gl.createTexture();
    dirtTexture = gl.createTexture();
    commTexture = gl.createTexture();
    
    cTexture = gl.createTexture();
    dTexture = gl.createTexture();
    fTexture = gl.createTexture();
    gTexture = gl.createTexture();
    aTexture = gl.createTexture();
    bTexture = gl.createTexture();
    
    loadStones();    
    
    var ctrokUniforms = {
	u_colorMult: [0.5, 0.0, 0.5, 1.0],
	u_matrix: m4.identity(),
    };
        
    programinfo = setupprograminfo();
       
        
    requestAnimationFrame(drawscene);
    
    function drawscene (time) {
	time *= 0.00005;
	webglUtils.resizeCanvasToDisplaySize(gl.canvas);
	gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
	gl.enable(gl.CULL_FACE);gl.enable(gl.DEPTH_TEST);
	gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	gl.clearColor(0, 0, 0.0, 1.0);
	var aspect = gl.canvas.clientWidth / gl.canvas.clientHeight;
	var projectionMatrix = m4.perspective(fieldOfViewRadians, aspect, 1, 2000);
	var cameraPosition = [camX, camY, camZ];target = calcTarget();
	var cameraMatrix = m4.lookAt(cameraPosition , target, up);
	var viewMatrix = m4.inverse(cameraMatrix);var viewProjectionMatrix = m4.multiply(projectionMatrix, viewMatrix);
	gl.useProgram(programinfo.program);
	
	var positionLocation = gl.getAttribLocation(programinfo.program, "a_position");
	var texcoordLocation = gl.getAttribLocation(programinfo.program, "a_texcoord");
	var size = 3;
	var type = gl.FLOAT;
	var normalize = false;
	var stride = 0;
	var offset = 0;
	gl.vertexAttribPointer(positionLocation, size, type, normalize, stride, offset);   
	gl.enableVertexAttribArray(texcoordLocation);   
	gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);	
	var size = 2;
	var type = gl.FLOAT; 
	var normalize = false;
	var stride = 0;
	var offset = 0;
	gl.vertexAttribPointer(texcoordLocation, size, type, normalize, stride, offset);

	for (var i in stones) {	    	    	    
	    drawCtrok(stones[i].textureName,
		      createFlattenedVertices(gl, loadVertices(stones[i].coords)),
		      ctrokUniforms,
		      gl, viewProjectionMatrix); }

	if (guideToggled){
	    drawPlaneGuide();
	    }
		  
	requestAnimationFrame(drawscene);
    }
}

function drawCtrok (textureRef,
		    ctrokBufferInfo,
		    ctrokUniforms,
		    gl,
		    viewProjectionMatrix)		   
{    
    eval('gl.bindTexture(gl.TEXTURE_2D,'
	 + textureRef + ')');
    
    webglUtils.setBuffersAndAttributes(
	gl, programinfo, ctrokBufferInfo);
    
    var ctrokXRotation = 0;
    var ctrokYRotation = 0;
    var ctrokTranslation   = [0, 0, 0];
    ctrokUniforms.u_matrix = computeMatrix(viewProjectionMatrix,ctrokTranslation,ctrokXRotation,ctrokYRotation);
    webglUtils.setUniforms(programinfo, ctrokUniforms);
    
    gl.drawArrays(gl.TRIANGLES, 0, ctrokBufferInfo.numElements);
}

function drawPlaneGuide () {            
    var vertices = [
            0.0 , 0.0 , 0.0,
            -40.0,  0.0, 0.0,            
    ]
    var vertex_buffer = gl.createBuffer();         
    gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);              
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);        
    gl.bindBuffer(gl.ARRAY_BUFFER, null);
    // gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);         
    //gl.clearColor(0, 1.0, 1.0, 1.0);
    gl.drawArrays(gl.LINES, 0, 2);
}
