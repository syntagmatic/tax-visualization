var Ajax = (function () {
    var a = 0,
        c, f, b, d = this;

    function e(j) {
        var i = document.createElement("script"),
            h = false;
        i.src = j;
        i.async = true;
        i.onload = i.onreadystatechange = function () {
            if (!h && (!this.readyState || this.readyState === "loaded" || this.readyState === "complete")) {
                h = true;
                i.onload = i.onreadystatechange = null;
                if (i && i.parentNode) {
                    i.parentNode.removeChild(i)
                }
            }
        };
        if (!c) {
            c = document.getElementsByTagName("head")[0]
        }
        c.appendChild(i)
    }
    function g(h, j) {
        f = "?";
        var i = "json" + (++a);
        d[i] = function (k) {
            j(k);
            d[i] = null;
            try {
                delete d[i]
            } catch (l) {}
        };
        e(h + "&callback=" + i);
        return i
    }
    return {
        get: g
    }
}());

function stringToXml(b) {
    if (window.ActiveXObject) {
        var a = new ActiveXObject("Microsoft.XMLDOM");
        a.async = "false";
        a.loadXML(b)
    } else {
        var c = new DOMParser();
        var a = c.parseFromString(b, "text/xml")
    }
    return a
};
