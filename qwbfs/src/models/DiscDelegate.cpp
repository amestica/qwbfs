/****************************************************************************
**
** 		Created using Monkey Studio v1.8.4.0b2 (1.8.4.0b2)
** Authors   : Filipe AZEVEDO aka Nox P@sNox <pasnox@gmail.com>
** Project   : qwbfs
** FileName  : DiscDelegate.cpp
** Date      : 2010-04-25T13:05:33
** License   : GPL
** Home Page : http://code.google.com/p/qwbfs
** Comment   : QWBFS Manager is a crossplatform WBFS Manager developed using Qt4/C++.
** It's currently working under Unix/Linux, Mac OS X, and build under windows (but not yet working).
** 
** DISCLAIMER: THIS APPLICATION COMES WITH NO WARRANTY AT ALL, NEITHER EXPRESS NOR IMPLIED.
** I DO NOT TAKE ANY RESPONSIBILITY FOR ANY DAMAGE TO YOUR WII CONSOLE OR WII PARTITION
** BECAUSE OF IMPROPER USAGE OF THIS SOFTWARE.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
****************************************************************************/
#include "DiscDelegate.h"
#include "DiscModel.h"
#include "qwbfsdriver/Driver.h"
#include "Gauge.h"
#include "datacache/DataNetworkCache.h"
#include "wiitdb/Covers.h"

#include <QPainter>
#include <QDebug>

using namespace QWBFS::Model;

DiscDelegate::DiscDelegate( QWBFS::Model::DiscModel* parent, DataNetworkCache* cache )
	: QStyledItemDelegate( parent )
{
	Q_ASSERT( parent );
	Q_ASSERT( cache );
	mModel = parent;
	mCache = cache;
}

DiscDelegate::~DiscDelegate()
{
}

void DiscDelegate::paint( QPainter* painter, const QStyleOptionViewItem& _option, const QModelIndex& index ) const
{
	QStyleOptionViewItemV4 option = _option;
    initStyleOption( &option, index );
	
	painter->setRenderHint( QPainter::Antialiasing );
	
	QPainterPath path;
	path.addRoundedRect( option.rect.adjusted( 2, 2, -2, -2 ), 8, 8 );
	
	const bool selected = option.state & QStyle::State_Selected;
	const QWBFS::Model::Disc disc = mModel->disc( index );
	
	// selection
	if ( selected ) {
		painter->save();
		painter->setPen( QColor( 145, 147, 255, 130 ) );
		painter->setBrush( QColor( 184, 153, 255, 130 ) );
		painter->drawPath( path );
		painter->restore();
	}
	// background
	else {
		painter->save();
		painter->setPen( Qt::NoPen );
		painter->setBrush( QColor( 200, 200, 200, index.row() %2 == 0 ? 100 : 60 ) );
		painter->drawPath( path );
		painter->restore();
	}
	
	QRect rect;
	QString text;
	
	// title/region
	{
		QFont font = painter->font();
		font.setPixelSize( 13 );
		font.setBold( true );
		
		QFontMetrics metrics( font );
		rect = option.rect.adjusted( 40, 2, -10, -( metrics.height() -2 ) );
		
		text = QString( "%1 - %2 (%3 - %4)" ).arg( disc.id ).arg( disc.title ).arg( QWBFS::Driver::regionToString( disc.region ) ).arg( QWBFS::Driver::regionToLanguageString( disc.region ) );
		text = metrics.elidedText( text, Qt::ElideRight, rect.width() );
		
		painter->save();
		painter->setFont( font );
		painter->drawText( rect, Qt::AlignLeft | Qt::AlignVCenter, text );
		painter->restore();
	}
	
	// size/origin
	{
		QFont font = painter->font();
		font.setPixelSize( 9 );
		
		QFontMetricsF metrics( font );
		rect = option.rect.adjusted( 40, rect.height(), -10, -2 );
		
		text = QString( "Estimated size: %1 - Origin: %2" ).arg( Gauge::fileSizeToString( disc.size ) ).arg( disc.origin );
		text = metrics.elidedText( text, Qt::ElideRight, rect.width() );
		
		painter->save();
		painter->setFont( font );
		painter->drawText( rect, Qt::AlignLeft | Qt::AlignVCenter, text );
		painter->restore();
	}
	
	QIcon icon;
	
	if ( disc.state == QWBFS::Driver::None ) {
		const QWBFS::WiiTDB::Covers cover( disc.id );
		QByteArray data;
		
		if ( mCache->hasCachedData( cover.url( QWBFS::WiiTDB::Covers::Disc ) ) ) {
			data = *mCache->cachedData( cover.url( QWBFS::WiiTDB::Covers::Disc ) );
		}
		else if ( mCache->hasCachedData( cover.url( QWBFS::WiiTDB::Covers::DiscCustom ) ) ) {
			data = *mCache->cachedData( cover.url( QWBFS::WiiTDB::Covers::DiscCustom ) );
		}
		else {
			mCache->cacheData( cover.url( QWBFS::WiiTDB::Covers::Disc ) );
		}
		
		if ( !data.isNull() ) {
			QPixmap pixmap;
			
			if ( pixmap.loadFromData( data ) ) {
				icon.addPixmap( pixmap );
			}
		}
	}
	else {
		icon.addPixmap( QPixmap( disc.state == QWBFS::Driver::Success ? ":/icons/256/success.png" : ":/icons/256/error.png" ) );
	}
	
	// icon
	if ( !icon.isNull() ) {
		rect = option.rect;
		rect = option.rect.adjusted( 8, 5, -rect.width() +40 -5, -5 );
		
		painter->save();
		painter->setClipRect( rect );
		icon.paint( painter, rect, Qt::AlignCenter );
		painter->restore();
	}
}

QSize DiscDelegate::sizeHint( const QStyleOptionViewItem& option, const QModelIndex& index ) const
{
	Q_UNUSED( option );
	Q_UNUSED( index );
	return QSize( -1, 37 );
}
