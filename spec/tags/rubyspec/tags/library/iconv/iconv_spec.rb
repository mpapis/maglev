fails:Iconv#iconv when given a positive length
fails:Iconv#iconv when given a negative length
fails:Iconv#iconv raises Iconv::IllegalSequence when faced with an invalid byte for the source encoding
fails:Iconv#iconv raises Iconv::IllegalSequence when a character cannot be represented on the target encoding
fails:Iconv#iconv raises Iconv::InvalidCharacter when an incomplete character or shift sequence happens at the end of the input buffer
fails:The 'utf-16' encoder emits an empty string when the source input is empty
