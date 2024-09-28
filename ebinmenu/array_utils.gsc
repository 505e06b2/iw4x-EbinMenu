array_contains(array, value) {
	for(i = 0; i < array.size; i++) {
		if(array[i] == value) return true;
	}

	return false;
}

array_append(array, value) {
	ret = [];
	foreach(item in array) ret[ret.size] = item;
	ret[ret.size] = value;
	return ret;
}

array_remove_at(array, index) {
	ret = [];
	for(i = 0; i < array.size; i++) {
		if(i == index) continue;
		ret[ret.size] = array[i];
	}
	return ret;
}

array_create(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z) {
	ret = [];
	if(isDefined(a)) ret[ret.size] = a;
	if(isDefined(b)) ret[ret.size] = b;
	if(isDefined(c)) ret[ret.size] = c;
	if(isDefined(d)) ret[ret.size] = d;
	if(isDefined(e)) ret[ret.size] = e;
	if(isDefined(f)) ret[ret.size] = f;
	if(isDefined(g)) ret[ret.size] = g;
	if(isDefined(h)) ret[ret.size] = h;
	if(isDefined(i)) ret[ret.size] = i;
	if(isDefined(j)) ret[ret.size] = j;
	if(isDefined(k)) ret[ret.size] = k;
	if(isDefined(l)) ret[ret.size] = l;
	if(isDefined(m)) ret[ret.size] = m;
	if(isDefined(n)) ret[ret.size] = n;
	if(isDefined(o)) ret[ret.size] = o;
	if(isDefined(p)) ret[ret.size] = p;
	if(isDefined(q)) ret[ret.size] = q;
	if(isDefined(r)) ret[ret.size] = r;
	if(isDefined(s)) ret[ret.size] = s;
	if(isDefined(t)) ret[ret.size] = t;
	if(isDefined(u)) ret[ret.size] = u;
	if(isDefined(v)) ret[ret.size] = v;
	if(isDefined(w)) ret[ret.size] = w;
	if(isDefined(x)) ret[ret.size] = x;
	if(isDefined(y)) ret[ret.size] = y;
	if(isDefined(z)) ret[ret.size] = z;
	return ret;
}

array_create_enum(values) {
	ret = [];
	for(i = 0; i < values.size; i++) {
		name = values[i][0];
		int_value = values[i][1];

		ret[name] = int_value;
		ret[int_value] = name;
	}
	return ret;
}
