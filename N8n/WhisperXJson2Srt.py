# Convert WhisperX transcription in JSON format to SRT format
import json
import sys
from pathlib import Path

# === CONFIG ===
# The maximum number of characters allowed in a single subtitle line.
MAX_CHARS = 45

# The time in seconds to consider as a pause between words, triggering a new line.
PAUSE_THRESHOLD = 1.0 # seconds

# The minimum number of words a line should have before it can be broken due to a pause or length limit.
# This prevents creating very short, fragmented lines.
MIN_WORDS_PER_LINE = 5

# Punctuation characters that can trigger a line break.
PUNCT_CHARS = ".?!,-:;"

# A line will be broken after a punctuation mark only if it's longer than this threshold.
# This prevents breaking very short sentences.
PUNCT_BREAK_THRESHOLD_CHARS = 30
# =============

def format_time(seconds):
    """Convert float seconds to SRT timestamp: 00:00:05,123"""
    if seconds is None:
        seconds = 0
    hrs = int(seconds // 3600)
    mins = int((seconds % 3600) // 60)
    secs = seconds % 60
    return f"{hrs:02d}:{mins:02d}:{secs:06.3f}".replace('.', ',')

def group_words_into_lines(all_words):
    """
    Groups a list of transcribed words into subtitle lines based on a set of rules.

    The function aims to create readable and well-formatted subtitles by breaking lines
    based on speaker changes, pauses in speech, punctuation, and line length.

    The rules are applied in a specific order of precedence:
    1. Speaker Change: A new line is always started when the speaker changes.
    2. Pause: A significant pause between words will trigger a new line, unless the current line is very short.
    3. Punctuation: The end of a sentence (marked by punctuation) will trigger a new line, if the sentence is long enough.
    4. Line Length: A line is broken if it exceeds MAX_CHARS, with additional logic to avoid creating orphaned words.

    Args:
        all_words (list): A list of word dictionaries from the WhisperX JSON output.
                          Each word dict should have "word", "start", "end", and "speaker".

    Returns:
        list: A list of tuples, where each tuple represents a subtitle line and contains
              (text, start_time, end_time, speaker).
    """
    lines = []
    current_line = []
    current_speaker = None
    last_word_end_time = None

    for word in all_words:
        w_speaker = word.get("speaker", "UNKNOWN")
        w_start = word.get("start")

        if not current_line:
            current_line.append(word)
            current_speaker = w_speaker
            if word.get("end") is not None:
                last_word_end_time = word.get("end")
            continue

        # --- Determine if a break is needed BEFORE adding the new word ---

        # Rule 1: Always break on speaker change.
        break_on_speaker_change = current_speaker != w_speaker

        # Rule 2: Break on pause, but only if the current line is not too short.
        # This prevents creating tiny lines from small hesitations.
        break_on_pause = False
        if last_word_end_time is not None and w_start is not None and w_start - last_word_end_time > PAUSE_THRESHOLD:
            if len(current_line) >= MIN_WORDS_PER_LINE:
                break_on_pause = True

        # Rule 3: Break after punctuation, if the line is reasonably long.
        # This helps to break lines at natural sentence endings.
        break_on_punct = False
        prev_word_text = current_line[-1]["word"].strip()
        if prev_word_text and prev_word_text[-1] in PUNCT_CHARS:
            current_line_text = " ".join([w["word"].strip() for w in current_line])
            if len(current_line_text) > PUNCT_BREAK_THRESHOLD_CHARS:
                break_on_punct = True

        # Rule 4: Break on line length, with logic to avoid orphaning words.
        break_on_length = False
        test_text = " ".join([w["word"].strip() for w in current_line + [word]])
        if len(test_text) > MAX_CHARS and len(current_line) >= MIN_WORDS_PER_LINE:
            word_text = word["word"].strip()
            # Avoid breaking if the new word itself ends a sentence, as it would be orphaned.
            # Example: "anything more." -> "more." would be on a new line.
            if word_text and word_text[-1] in PUNCT_CHARS:
                pass # Don't break, append the word to the current line.
            else:
                break_on_length = True

        if break_on_speaker_change or break_on_pause or break_on_punct or break_on_length:
            # A break is needed, so flush the current line.
            line_text = " ".join([w["word"].strip() for w in current_line])
            lines.append((line_text, current_line[0].get("start"), current_line[-1].get("end"), current_speaker))
            # Start a new line with the current word.
            current_line = [word]
            current_speaker = w_speaker
        else:
            # No break needed, so append the word to the current line.
            current_line.append(word)

        if word.get("end") is not None:
            last_word_end_time = word.get("end")

    # Flush the final line after the loop.
    if current_line:
        line_text = " ".join([w["word"].strip() for w in current_line])
        lines.append((line_text, current_line[0].get("start"), current_line[-1].get("end"), current_speaker))

    return lines

# === MAIN ===
if len(sys.argv) != 2:
    print("Usage: python make_subtitles.py <input.json>")
    sys.exit(1)

json_path = Path(sys.argv[1])
if not json_path.exists():
    print(f"File not found: {json_path}")
    sys.exit(1)

with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Collect ALL words from ALL segments into a single list.
# The grouping logic will handle line breaks within and between segments.
all_words = []
for segment in data.get("segments", []):
    if "words" in segment:
        all_words.extend(segment["words"])

if not all_words:
    print("No word-level data found in JSON.")
    sys.exit(1)

# Generate subtitle lines using the grouping logic.
subtitle_lines = group_words_into_lines(all_words)

# Write the generated lines to an SRT file.
srt_path = json_path.with_suffix('.srt')
with open(srt_path, 'w', encoding='utf-8') as f:
    for i, (text, start, end, speaker) in enumerate(subtitle_lines, 1):
        start_str = format_time(start)
        end_str = format_time(end)
        f.write(f"{i}\n{start_str} --> {end_str}\n[{speaker}]: {text}\n\n")

print(f"SRT saved: {srt_path}")
print(f"   - {len(subtitle_lines)} subtitle lines")
