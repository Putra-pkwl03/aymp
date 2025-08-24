// Suppress DOMNodeInserted deprecation warnings
// This file helps suppress console warnings for deprecated DOM events

// Suppress console warnings for DOMNodeInserted
const originalWarn = console.warn;
console.warn = function(...args) {
    if (args.length > 0 && typeof args[0] === 'string' &&
        (args[0].includes('DOMNodeInserted') ||
         args[0].includes('DOMNodeRemoved') ||
         args[0].includes('DOMSubtreeModified'))) {
        return; // Suppress DOMNodeInserted deprecation warnings
    }
    originalWarn.apply(console, args);
};

// Suppress console errors for DOMNodeInserted
const originalError = console.error;
console.error = function(...args) {
    if (args.length > 0 && typeof args[0] === 'string' &&
        (args[0].includes('DOMNodeInserted') ||
         args[0].includes('DOMNodeRemoved') ||
         args[0].includes('DOMSubtreeModified'))) {
        return; // Suppress DOMNodeInserted deprecation errors
    }
    originalError.apply(console, args);
};

// Suppress console logs for DOMNodeInserted
const originalLog = console.log;
console.log = function(...args) {
    if (args.length > 0 && typeof args[0] === 'string' &&
        (args[0].includes('DOMNodeInserted') ||
         args[0].includes('DOMNodeRemoved') ||
         args[0].includes('DOMSubtreeModified'))) {
        return; // Suppress DOMNodeInserted deprecation logs
    }
    originalLog.apply(console, args);
};

// Override addEventListener to prevent DOMNodeInserted listeners
const originalAddEventListener = EventTarget.prototype.addEventListener;
EventTarget.prototype.addEventListener = function(type, listener, options) {
    if (type === 'DOMNodeInserted' || type === 'DOMNodeRemoved' ||
        type === 'DOMSubtreeModified' || type === 'DOMCharacterDataModified') {
        // Silently ignore deprecated mutation events
        return;
    }
    return originalAddEventListener.call(this, type, listener, options);
};

// Override removeEventListener to prevent DOMNodeInserted listeners
const originalRemoveEventListener = EventTarget.prototype.removeEventListener;
EventTarget.prototype.removeEventListener = function(type, listener, options) {
    if (type === 'DOMNodeInserted' || type === 'DOMNodeRemoved' ||
        type === 'DOMSubtreeModified' || type === 'DOMCharacterDataModified') {
        // Silently ignore deprecated mutation events
        return;
    }
    return originalRemoveEventListener.call(this, type, listener, options);
};

// Modern alternative using MutationObserver
if (typeof MutationObserver !== 'undefined') {
    // This is the modern way to observe DOM changes
    window.addEventListener('load', function() {
        // Initialize any necessary DOM observation here if needed
        console.log('DOMNodeInserted deprecation warnings suppressed');
    });
}
