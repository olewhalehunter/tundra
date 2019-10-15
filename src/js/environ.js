//// Tundra Client Environment
//
var slabFile = "";
var slabTexture = "";
var slabx = 0; var slabz = 0; var slaby = 0;
var slabStack = {};
var pointStack = [];
var pointMap = {};
var slabString = "";

function newSlab(file, textureName){
  console.log('Defining slabs for texture var ' + textureName);
  // 'bark.jpg', 'barkTexture'  
  slabFile = file; 
  slabTexture = textureName; 
  var s = slab(
      file, slabTexture,    
      eval(formatCoords(pointStack.slice(0,4))));

  addSlab(s);
  svStr = 'var ' + slabTexture + 'Slab = ';
  sStr = 'slab("' +
	slabFile + '" ,"' + slabTexture + '", ' 
	+ formatCoords(
	    pointStack.slice(0, 4) ) + ')'; 
  svStr = svStr + sStr;
  slabString = slabString + sStr + ",";
  console.log(sStr);
}

function barkSlab () {
  newSlab('bark.jpg', 'barkTexture'); }

function shadeSlab () {
  newSlab('shade.jpg', 'shadeTexture'); }

function formatCoords (x) { 
  var out = '[';
  for (var i in x) {
   x[i] = x[i].slice(1);
   out = out + "["
      for (var j in x[i]) {
	  out = out + x[i][j] + ",";}
      out = out + "],"}
    out = out + "]";
    return out;
}


function cursor () { 
  console.log('x: ' + slabx + ' , z: ' + slabz + ' , y:' + slaby) }

function point (name) {  
  pointMap[name] = [slabx, slaby, slabz]; }

function getPoint (name) {
 pointStack.push(name, pointMap[name]); }

function higher (n) { 
     slaby = slaby + n;  }

function lower(n) {
     slaby = slaby - n;  }

function xz (x, z) { 
  slabx = x; 
  slabz = z;  }

function xyz (x, y, z) {
 xz(x, z); slaby = y; }

function xzy (x, z, y) { xyz(x,y,z); }

function slab (img, name, coords){
    return { 'texture' : img,
	     'textureName' : name,
	     'coords' : coords } }

function addSlab (x) { 
  stones.push(x) 
}

var pointSamp = [3, 5, 4];

dyn = slab("ink.jpeg",
          // stoneTexture vars declared in /tundra-client.js
	  "inkTexture",           
	  [[3, 0, -20],
	   [3, 12, 20],
	   [70, 10, 3],
	   [70 , 0, 8]]);

stones =
    [slab("bark.jpg",
	  "barkTexture",
	  [[-4, 0, -40],
	   [-4, 0, 40],
	   [70, 0, +40],
	   [70 , 0, -40]])
     ,
     slab("bark.jpg",
	  "barkTexture",
	  [[-4, 38, -40],
	   [-4, 80, 40],
	   [-4, 0,  50.0],
	   [-4 , 0, -40]])];
     
   
// Environment Loading

function loadStones () {
    for (var i in stones) {
	if (stones[i].textureName == "commTexture"){
	    stones[i].texture = "out.png#" + (new Date()).getTime();
	}
	console.log('textureSelect("' + stones[i].texture
		    + '", ' + stones[i].textureName + ');');	
	eval('textureSelect("' + stones[i].texture
	     + '", ' + stones[i].textureName + ');');
    }
}
function loadVertices(vertices) {
    var faceNormals = [[+1, +0, +0],[-1, +0, +0]];
    var uvCoords = [[1, 0], [0, 0], [0, 1], [1, 1], ];    
    var quadCount = 2;
    var numVertices = quadCount * 4;    
    var positions = webglUtils.createAugmentedTypedArray(3, numVertices);
    var normals   = webglUtils.createAugmentedTypedArray(2, numVertices);
    var texCoords = webglUtils.createAugmentedTypedArray(2 , numVertices);
    var indices   = webglUtils.createAugmentedTypedArray(3, 6 * 4, Uint16Array);
    var faceIndices = [3, 7, 5, 1];   
    
    for (var v = 0; v < 4; ++v) {
        var position = vertices[v];
	if (! position) {
	    console.log("undefined positiion");
	}
        var normal = faceNormals[0];
        var uv = uvCoords[v];	
        positions.push(position);
        normals.push(normal);
        texCoords.push(uv);
    }	
    indices.push(2, 0, 1);
    indices.push(3, 0, 2);

    indices.push(2, 1, 0);
    indices.push(3, 2, 0);
    return {
	position: positions,
	normal: normals,
	texcoord: texCoords,
	indices: indices,
    };
}

