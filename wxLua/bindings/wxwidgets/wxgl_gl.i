// ===========================================================================
// Purpose:     wxGL library
// Author:      J Winwood, John Labenski
// Created:     14/11/2001
// Copyright:   (c) 2001-2002 Lomtick Software. All rights reserved.
// Licence:     wxWidgets licence
// wxWidgets:   Updated to 2.8.4
// ===========================================================================

//#if wxUSE_OPENGL // FIXME ? Is it probably enough to test for wxUSE_GLCANVAS

// ---------------------------------------------------------------------------
// wxGLCanvas

#if wxLUA_USE_wxGLCanvas && wxUSE_GLCANVAS

// FIXME : Need to wrap wxGLApp?

#include "wx/glcanvas.h"

enum
{
    WX_GL_RGBA,
    WX_GL_BUFFER_SIZE,
    WX_GL_LEVEL,
    WX_GL_DOUBLEBUFFER,
    WX_GL_STEREO,
    WX_GL_AUX_BUFFERS,
    WX_GL_MIN_RED,
    WX_GL_MIN_GREEN,
    WX_GL_MIN_BLUE,
    WX_GL_MIN_ALPHA,
    WX_GL_DEPTH_SIZE,
    WX_GL_STENCIL_SIZE,
    WX_GL_MIN_ACCUM_RED,
    WX_GL_MIN_ACCUM_GREEN,
    WX_GL_MIN_ACCUM_BLUE,
    WX_GL_MIN_ACCUM_ALPHA
};

class wxGLCanvas : public wxWindow
{
#if !%wxchkver_3_0
    wxGLCanvas(wxWindow* parent, wxWindowID id = wxID_ANY, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style=0, const wxString& name="GLCanvas", int attribList[] = 0, const wxPalette& palette = wxNullPalette );
    wxGLCanvas(wxWindow* parent, wxGLContext* sharedContext, wxWindowID id = -1, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style=0, const wxString& name="GLCanvas", int attribList[] = 0, const wxPalette& palette = wxNullPalette );
    wxGLCanvas(wxWindow* parent, wxGLCanvas* sharedCanvas, wxWindowID id = -1, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style=0, const wxString& name="GLCanvas", int attribList[] = 0, const wxPalette& palette = wxNullPalette );
    !%mac wxGLCanvas(wxWindow* parent, wxWindowID id = wxID_ANY, int attribList[] = 0, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style=0, const wxString& name="GLCanvas", const wxPalette& palette = wxNullPalette );
#endif

#if %wxchkver_3_0
    !%mac wxGLCanvas(wxWindow* parent, wxWindowID id = wxID_ANY, int attribList[] = 0, const wxPoint& pos = wxDefaultPosition, const wxSize& size = wxDefaultSize, long style=0, const wxString& name="GLCanvas", const wxPalette& palette = wxNullPalette );
#endif

    //wxGLContext* GetContext() const; - removed in wx 3.0
    %mac void SetCurrent( );
    %wxchkver_2_8&!%mac void SetCurrent(const wxGLContext& RC) const;

    void SetColour(const wxString& colour );
    void SwapBuffers( );
};

// ---------------------------------------------------------------------------
// wxGLContext

class wxGLContext : public wxObject
{
    #if %wxchkver_2_8
        !%mac wxGLContext(wxGLCanvas *win, const wxGLContext* other = NULL ); // FIXME

        !%mac | %wxchkver_2_9 void SetCurrent(const wxGLCanvas& win) const;
        %mac & !%wxchkver_2_9 void SetCurrent() const;
    #endif // %wxchkver_2_8

    #if !%wxchkver_2_8
        wxGLContext(bool isRGB, wxGLCanvas* win, const wxPalette& palette = wxNullPalette );
        wxGLContext(bool isRGB, wxGLCanvas* win, const wxPalette& palette = wxNullPalette, const wxGLContext* other = NULL );

        const wxWindow*  GetWindow( );
        void SetCurrent( );
        void SetColour(const wxString& colour );
        void SwapBuffers( );
    #endif // !%wxchkver_2_8
};

#endif //wxLUA_USE_wxGLCanvas && wxUSE_GLCANVAS

//#endif wxUSE_OPENGL
