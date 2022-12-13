"""app URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include, re_path

from django.conf import settings
from django.conf.urls.static import static

"""
    SE PRESTA DE FORMA INICIAL 'urlpatterns' VACÍO PAR PODER VISUALIZAR EL "/" IMPLICITO DE LA INSTALACIÓN DE DEJANGO (HOME SIMULADO)
    CUANDO SE ACTIVA ALGUNA URL (INCLUSO EL DEBUG_TOOLBAR) EL '/' DE DJANGO DEJA DE FUNCIONAR, SIENDO NECESARIO INDICAR NOSOTROS UN NUEVO "/"
"""

admin.site.site_header = 'XXX'
admin.site.site_title = 'XXX'
admin.site.site_url = 'XXX'
admin.site.index_title = 'XXXX'
# admin.empty_value_display = '**Empty**'

urlpatterns = [
    re_path(r'^admin/', include('admin_honeypot.urls', namespace='admin_honeypot')),      # Para activar el falso admin de "admin_honey_pot"
    path('admin2/', admin.site.urls),                                                     # Para activar el verdadero admin
    # path('django-sb-admin/', include('django_sb_admin.urls')),                            # PARA VER EL SAMPLE DE sb-admin
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

if settings.DEBUG_TOOLBAR:
    import debug_toolbar
    urlpatterns = [
        path('__debug__/', include(debug_toolbar.urls)),
    ] + urlpatterns
