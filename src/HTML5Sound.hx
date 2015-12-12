import js.html.SourceElement;
import js.html.AudioElement;
import js.Browser;

@:expose @:keep class HTML5Sound extends BaseSound implements ISound {

	var _snd:AudioElement;
	var _src:SourceElement;

	public function new(url:String, ?options:WaudSoundOptions = null) {
		super(url, options);

		_snd = Browser.document.createAudioElement();
		addSource(url);

		if (_options.autoplay) _snd.autoplay = true;
		_snd.volume = _options.volume;

		if (Std.string(_options.preload) == "true") _snd.preload = "auto";
		else if (Std.string(_options.preload) == "false") _snd.preload = "none";
		else _snd.preload = "metadata";

		if (_options.onload != null) {
			_snd.onloadeddata = function() {
				_options.onload(this);
			}
		}

		_snd.onended = function() {
			_isPlaying = false;
			if (_options.onend != null) _options.onend(this);
		}

		if (_options.onerror != null) {
			_snd.onerror = function() {
				_options.onerror(this);
			}
		}

		Waud.sounds.set(url, this);

		_snd.load();
	}

	function addSource(src:String):SourceElement {
		_src = Browser.document.createSourceElement();
		_src.src = src;

		if (Waud.types.get(_getExt(src)) != null) _src.type = Waud.types.get(_getExt(src));
		_snd.appendChild(_src);

		return _src;
	}

	function _getExt(filename:String):String {
		return filename.split(".").pop();
	}

	public function setVolume(val:Float) {
		if (val >= 0 && val <= 1) {
			_snd.volume = val;
			_options.volume = val;
		}
	}

	public function getVolume():Float {
		return _options.volume;
	}

	public function mute(val:Bool) {
		_snd.muted = val;
	}

	public function play() {
		_snd.play();
	}

	public function isPlaying():Bool {
		return _isPlaying;
	}

	public function loop(val:Bool) {
		_snd.loop = val;
	}

	public function stop() {
		_snd.pause();
		_snd.currentTime = 0;
	}
}