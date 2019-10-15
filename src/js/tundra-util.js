// Tundra WebGL Setup + Helper Funcs
//

var gl;
var canvas;

function glcanvassetup (){
    canvas = document.getElementById("canvas");
    gl = canvas.getContext("webgl");
    if (!gl) {	
	return;
    }
}

function setupprograminfo () {
   return webglUtils.createProgramInfo(gl, ["3d-vertex-shader", "3d-fragment-shader"]);
}

// Camera Functions
// 

function degToRad(d) {
    return d * Math.PI / 180;
}

function isPowerOf2(value) {
    return (value & (value - 1)) === 0;
}

function radToDeg(r) {
    return r * 180 / Math.PI;
}

var cameraAngleRadians = degToRad(0);
var fieldOfViewRadians = degToRad(60);

function computeMatrix(viewProjectionMatrix, translation, xRotation, yRotation) {
    var matrix = m4.translate(viewProjectionMatrix,
			      translation[0],
			      translation[1],
			      translation[2]);
    matrix = m4.xRotate(matrix, xRotation);
    return m4.yRotate(matrix, yRotation);
}

// Camera State
//

var up = [0, 1, 0];
var camX, camY, camZ,
    camYaw, camPitch;
var target;
camX = 0;
camY = 30;
camZ = 0;
camYaw = 0;
camPitch = 3.14;

function calcTarget (){
    return [camX + 2.0 * Math.cos(camYaw),
	    camY + Math.cos(camPitch),
	    camZ + 2.0 * Math.sin(camYaw)];
}

function rotateYaw() { camYaw += 0.1; }
function rotateYaw(x) { camYaw += x; }
function rotatePitch() { camPitch += 0.1; }
function rotatePitch(x) { camPitch += x; }

function goForward (scale) {
    camX += scale * Math.cos(camYaw);
    camZ += scale * Math.sin(camYaw);
}

function goBack (scale) {
    camX -= scale * Math.cos(camYaw);
    camZ -= scale * Math.sin(camYaw);
}

// Keyboard Input
//

document.addEventListener('keydown', function(event) {
    //console.log(event.keyCode);
    if(event.keyCode == 65) { // a
	// goLeft
    }
    else if(event.keyCode == 91) { // d
	// goRight
    }
    else if(event.keyCode == 87) { // w
	goForward(13.0);
    }
    else if(event.keyCode == 83) { // s
	goBack(13.0);
    }
});



var createFlattenedVertices = function(gl, vertices) {
    return webglUtils.createBufferInfoFromArrays(
        gl,primitives.makeRandomVertexColors(
            primitives.deindexVertices(vertices),
            {
		vertsPerColor: 6,
		rand: function(ndx, channel) {
                    return channel < 3 ? ((180 + Math.random() * 50) | 0) : 255;
		}
            })
    );
};




