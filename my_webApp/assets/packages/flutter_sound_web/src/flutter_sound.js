/*
 * Copyright 2018, 2019, 2020 Dooboolab.
 *
 * This file is part of Flutter-Sound.
 *
 * Flutter-Sound is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 3 (LGPL-V3), as published by
 * the Free Software Foundation.
 *
 * Flutter-Sound is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Flutter-Sound.  If not, see <https://www.gnu.org/licenses/>.
 */

const VERSION = '9.17.0'


const VERBOSE = 0;
const DBG = 1;
const INFO = 2;
const WARNING = 3;
const ERROR = 4;
const WTF = 5;
const NOTHING = 6;




const codec =
                {
                        defaultCodec:   'defaultCodec',
                        aacADTS:        'aacADTS',
                        opusOGG:        'opusOGG',
                        opusCAF:        'opusCAF',
                        mp3:            'mp3',
                        vorbisOGG:      'vorbisOGG',
                        pcm16:          'pcm16',
                        pcm16WAV:       'pcm16WAV',
                        pcm16AIFF:      'pcm16AIFF',
                        pcm16CAF:       'pcm16CAF',
                        flac:           'flac',
                        aacMP4:         'aacMP4',
                        amrNB:          'amrNB',
                        amrWB:          'amrWB',
                        pcm8:           'pcm8',
                        pcmFloat32:     'pcmFloat32',
                        pcmWebM:        'pcmWebM',
                        opusWebM:       'opusWebM',
                        vorbisWebM:     'vorbisWebM',
                };


const tabCodec =
                [
                        codec.opusWebM, // codec.defaultCodec,
                        codec.aacADTS,
                        codec.opusOGG,
                        codec.opusCAF,
                        codec.mp3,
                        codec.vorbisOGG,
                        codec.pcm16,
                        codec.pcm16WAV,
                        codec.pcm16AIFF,
                        codec.pcm16CAF,
                        codec.flac,
                        codec.aacMP4,
                        codec.amrNB,
                        codec.amrWB,
                        codec.pcm8,
                        codec.pcmFloat32,
                        codec.pcmWebM,
                        codec.opusWebM,
                        codec.vorbisWebM,
                ];

const mime_types =
                [
                        'audio/webm\;codecs=opus', // defaultCodec,
                        'audio/aac', // aacADTS, //*
                        'audio/opus\;codecs=opus', // opusOGG, // 'audio/ogg' 'audio/opus'
                        'audio/x-caf', // opusCAF,
                        'audio/mpeg', // mp3, //*
                        'audio/ogg\;codecs=vorbis', // vorbisOGG,// 'audio/ogg' // 'audio/vorbis'
                        'audio/pcm', // pcm16,
                        'audio/wav\;codecs=1', // pcm16WAV,
                        'audio/aiff', // pcm16AIFF,
                        'audio/x-caf', // pcm16CAF,
                        'audio/x-flac', // flac, // 'audio/flac'
                        'audio/mp4', // aacMP4, //*
                        'audio/AMR', // amrNB, //*
                        'audio/AMR-WB', // amrWB, //*
                        'audio/pcm', // pcm8,
                        'audio/pcm', // pcmFloat32,
                        'audio/webm\;codecs=pcm', // pcmWebM,
                        'audio/webm\;codecs=opus', // opusWebM,
                        'audio/webm\;codecs=vorbis', // vorbisWebM
                ];

const tabFormat =
                [
                        'opus', // defaultCodec,
                        'aac', // aacADTS,
                        'opus', // opusOGG,
                        'caf', // opusCAF,
                        'mp3', // mp3,
                        'vorbis', // vorbisOGG,
                        '', // pcm16,
                        'wav', // pcm16WAV,
                        'aiff', // pcm16AIFF,
                        'caf', // pcm16CAF,
                        'flac', // flac,
                        'mp4', // aacMP4,
                        'AMR', // amrNB,
                        'AMR-WB', // amrWB,
                        '', // pcm8,
                        '', // pcmFloat32,
                        'pcm', // pcmWebM,
                        'opus', // opusWebM,
                        'webm', // vorbisWebM

                ];



var instanceNumber = 0;
var lastUrl = '';



function getRecordURL( aPath,)
{
        var path ;
        var myStorage;
        if ((aPath == null) || (aPath == ''))
        {
                path = lastUrl;
        } else
        {
                path =  aPath;

        }
        if (path.substring(0,1) == '/')
        {
                myStorage = window.localStorage;
        } else
        {
                myStorage = window.sessionStorage;
        }

        var url = myStorage.getItem(path);
        return url;
}



