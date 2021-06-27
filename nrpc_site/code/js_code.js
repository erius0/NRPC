function addToCart(id) {
    var cookies = document.cookie;
    var arr = cookies.split(';');
    for (var i = 0; i < arr.length; i++) {
        var tmp = arr[i].trim().split('=');
        if (tmp[0] === 'cart') {
            if (tmp[1].includes(id))
                break;
            var new_cookie = tmp[0] + "=" + tmp[1] + "." + id + "; " + "path=/;";
            document.cookie = new_cookie;
            break;
        }
    }
    var btn = document.getElementById('buy_part' + id);
    btn.value = 'В корзине';
    btn.setAttribute("onClick", "removeFromCart(" + id + ");");
    btn.setAttribute("class", "incart");
    cartCount();
}

function removeFromCart(id) {
    var cookies = document.cookie;
    var arr = cookies.split(';');
    for (var i = 0; i < arr.length; i++) {
        var tmp = arr[i].trim().split('=');
        if (tmp[0] === 'cart') {
            var ids = tmp[1].split('.');
            var result = '';
            for (var j = 0; j < ids.length; j++)
                if (ids[j] != id)
                    result += '.' + ids[j];
            result = result.substring(1, result.length);
            var new_cookie = tmp[0] + '=' + result + ';' + 'path=/;';
            document.cookie = new_cookie;
            break;
        }
    }
    if (!cartCount()) {
        var tmp = document.getElementById('cart');
        if (tmp !== null)
            tmp.innerHTML = 'Ваша корзина пуста, зайдите в <a href="shopping.php">каталог</a> и выберите товары для покупки';
    }
    var btn = document.getElementById('buy_part' + id);
    if (btn !== null) {
        btn.value = 'Купить';
        btn.setAttribute("onClick", "addToCart(" + id + ");");
        btn.setAttribute("class", "buy");
    }
}

function askLogin() {
    alert('Для покупки комплектующих требуется войти в свой аккаунт');
}

function cartCount() {
    var notif = document.getElementById('notif');
    var cart = document.cookie;
    var arr = cart.split(' ');
    for (var i = 0; i < arr.length; i++) {
        var tmp = arr[i].split('=');
        if (tmp[0] === 'cart') {
            var prev_result = tmp[1].substring(0, tmp[1].length - 1);
            var ids = prev_result.split('.');
            var count = ids.length - 1;
            if (count > 0) {
                notif.textContent = '•';
                notif.style.visibility = 'visible';
                return true;
            } else {
                notif.style.visibility = 'hidden';
                return false;
            }
        }
    }
}

function specifyShop() {
    alert('Для покупки комплектующих требуется указать магазин в разделе "Профиль"');
}

function up(id) {
    var counter = document.getElementById('value' + id);
    counter.stepUp(1);
    var count = parseInt(counter.value);
    var price = document.getElementById('price' + id);
    var float_price = parseFloat(price.value);
    var result = (count * float_price).toFixed(2) + " ₽";
    document.getElementById('price_display' + id).textContent = result;
}

function down(id) {
    var counter = document.getElementById('value' + id);
    if (counter.value === '1') {
        var conf = confirm('Убрать данный товар из корзины?');
        if (conf) {
            var part = document.getElementById('part_entry' + id);
            part.parentNode.removeChild(part);
            var btn = document.getElementById('make_order');
            btn.parentNode.removeChild(btn);
            removeFromCart(id);
        }
        return;
    }
    counter.stepDown(1);
    var count = parseInt(counter.value);
    var price = document.getElementById('price' + id);
    var float_price = parseFloat(price.value);
    var result = (count * float_price).toFixed(2) + " ₽";
    document.getElementById('price_display' + id).textContent = result;
}

function checkCartEmpty() {
    var cart = document.cookie;
    var arr = cart.split(' ');
    for (var i = 0; i < arr.length; i++) {
        var tmp = arr[i].split('=');
        if (tmp[0] === 'cart') {
            if (tmp[1].length < 3)
                return;
        }
    }
    return '';
}

function openWindow(link) {
    window.open(link);
}