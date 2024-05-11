/* Cydia Substrate - Powerful Code Insertion Platform
 * Copyright (C) 2008-2015  Jay Freeman (saurik)
*/

(function(exports) {

var pool = new (typedef apr_pool_t *);
apr_pool_create(pool, null);

var libsubstrate = new (typedef apr_dso_handle_t *);
if (apr_dso_load(libsubstrate, Cycript.specific + "/libsubstrate." + Cycript.extension, *pool) != 0) {
    exports.error = dlerror();
    return;
}

extern "C" void *MSGetImageByName(const char *);
extern "C" void *MSFindSymbol(void *, const char *);
extern "C" void MSHookFunction(void *, void *, void **);
extern "C" void MSHookMessageEx(Class, SEL, void *, void **);

var slice = Array.prototype.slice;

exports.getImageByName = MSGetImageByName;
exports.findSymbol = MSFindSymbol;

exports.hookFunction = function(func, hook, old) {
    var type = typeid(func);

    var pointer;
    if (old == null || typeof old === "undefined")
        pointer = null;
    else {
        pointer = new (typedef void **);
        *old = function() { return type(*pointer).apply(null, arguments); };
    }

    MSHookFunction(func.valueOf(), type(hook), pointer);
};

exports.hookMessage = function(isa, sel, imp, old) {
    var type = sel.type(isa);

    var pointer;
    if (old == null || typeof old === "undefined")
        pointer = null;
    else {
        pointer = new (typedef void **);
        *old = function() { return type(*pointer).apply(null, [this, sel].concat(slice.call(arguments))); };
    }

    MSHookMessageEx(isa, sel, type(function(self, sel) { return imp.apply(self, slice.call(arguments, 2)); }), pointer);
};

})(exports);
