
function $get_byid(id){
	return typeof id === 'string' ? document.getElementById(id) : id;
}

function getMinBoxIndex(value,array) {

	for (var i in array) {
		if (array[i] == value) {
			return i;
		}
	}
}


function waterFall(parent,box) {
	var allBox = $get_byid(parent).getElementsByClassName(box);
	var boxWidth = allBox[0].offsetWidth;
	var screenWidth = document.body.offsetWidth;
	var cols = Math.floor(screenWidth/boxWidth);

	$get_byid(parent).style.width = boxWidth * cols + 'px';
	$get_byid(parent).style.margin = '0 auto';

	var heightArr = [];

	for (var i = 0; i < allBox.length; i++) {
		var boxHeight = allBox[i].offsetHeight;
		if (i<cols) {
			heightArr.push(boxHeight);
		}else{
			var minBoxHeight = Math.min.apply(this,heightArr);
			console.log(minBoxHeight);

			var minBoxIndex = getMinBoxIndex(minBoxHeight,heightArr);

			allBox[i].style.position = 'absolute';
			allBox[i].style.top = minBoxHeight + 'px';
			allBox[i].style.left = minBoxIndex * boxWidth + 'px';

			heightArr[minBoxIndex] += boxHeight;
		}
	}
}


function checkWillLoad() {
	var allBox = $get_byid('main').getElementsByClassName('box');
	var lastBox = allBox[allBox.length - 1];
	var lastBoxOffsetTop = lastBox.offsetTop;
	var screenHeight = document.body.offsetHeight || document.documentElement.clientHeight;
	var scrollTop = document.body.scrollTop;
	return lastBoxOffsetTop <= scrollTop + screenHeight;
}


if (checkWillLoad()) {
	var data = {
		'dataImg':[{'img':'/images/avatar/201711/dd3232a74724638d72c1d4cfc0e484ff14.jpg'}]
	};

	for (var i = 0; i < data.dataImg.length; i++) {
		var newBox = document.createElement('div');
		newBox.className = 'box';
		$get_byid('main').appendChild(newBox);

		var newPic = document.createElement('div');
		newPic.className = 'pic';
		newBox.appendChild(newPic);

		var newImg = document.createElement('img');
		newImg.src = 'images/' + data.dataImg[i].img;
		newPic.appendChild(newImg);
	}

	waterFall('main','box');
}
waterFall('main','box');