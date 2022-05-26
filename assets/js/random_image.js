window.onload = displayImage;

var imagesArray = [ 
    "anime4.png"
];

function displayImage(){
    var num = Math.floor(Math.random() * (imagesArray.length));
    document.getElementById("main_image1").src = "assets/img/animes/" + imagesArray[num];
}
